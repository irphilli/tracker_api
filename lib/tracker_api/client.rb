module TrackerApi
  class Client
    USER_AGENT          = "Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}) TrackerApi/#{TrackerApi::VERSION} Faraday/#{Faraday::VERSION}".freeze

    # Header keys that can be passed in options hash to {#get},{#paginate}
    CONVENIENCE_HEADERS = Set.new([:accept, :content_type])

    attr_reader :url, :api_version, :token, :logger, :connection, :auto_paginate, :last_response

    # Create Pivotal Tracker API client.
    #
    # @param [Hash] options the connection options
    # @option options [String] :token API token to use for requests
    # @option options [String] :url Main HTTP API root
    # @option options [Boolean] :auto_paginate Client should perform pagination automatically. Default true.
    # @option options [String] :api_version The API version URL path
    # @option options [String] :logger Custom logger
    # @option options [String] :adapter Custom http adapter to configure Faraday with
    # @option options [String] :connection_options Connection options to pass to Faraday
    #
    # @example Creating a Client
    #   Client.new token: 'my-super-special-token'
    def initialize(options={})
      url                = options.fetch(:url, 'https://www.pivotaltracker.com')
      @url               = Addressable::URI.parse(url).to_s
      @api_version       = options.fetch(:api_version, '/services/v5')
      @logger            = options.fetch(:logger, ::Logger.new(nil))
      adapter            = options.fetch(:adapter, :excon)
      connection_options = options.fetch(:connection_options, { ssl: { verify: true } })
      @auto_paginate     = options.fetch(:auto_paginate, true)
      @token             = options[:token]
      raise 'Missing required options: :token' unless @token

      @connection = Faraday.new({ url: @url }.merge(connection_options)) do |builder|
        # response
        builder.use Faraday::Response::RaiseError
        builder.response :json

        # request
        builder.request :multipart
        builder.request :json

        builder.use TrackerApi::Logger, @logger
        builder.adapter adapter
      end
    end

    # Make a HTTP GET request
    #
    # @param path [String] The path, relative to api endpoint
    # @param options [Hash] Query and header params for request
    # @return [Faraday::Response]
    def get(path, options = {})
      request(:get, parse_query_and_convenience_headers(path, options))
    end

    # Make a HTTP POST request
    #
    # @param path [String] The path, relative to api endpoint
    # @param options [Hash] Query and header params for request
    # @return [Faraday::Response]
    def post(path, options = {})
      request(:post, parse_query_and_convenience_headers(path, options))
    end

    # Make a HTTP PUT request
    #
    # @param path [String] The path, relative to api endpoint
    # @param options [Hash] Query and header params for request
    # @return [Faraday::Response]
    def put(path, options = {})
      request(:put, parse_query_and_convenience_headers(path, options))
    end

    # Make one or more HTTP GET requests, optionally fetching
    # the next page of results from information passed back in headers
    # based on value in {#auto_paginate}.
    #
    # @param path [String] The path, relative to {#api_endpoint}
    # @param options [Hash] Query and header params for request
    # @param block [Block] Block to perform the data concatenation of the
    #   multiple requests. The block is called with two parameters, the first
    #   contains the contents of the requests so far and the second parameter
    #   contains the latest response.
    # @return [Array]
    def paginate(path, options = {}, &block)
      opts           = parse_query_and_convenience_headers path, options.dup
      auto_paginate  = opts[:params].delete(:auto_paginate) { |k| @auto_paginate }
      @last_response = request :get, opts
      data           = @last_response.body
      raise TrackerApi::Errors::UnexpectedData, 'Array expected' unless data.is_a? Array

      if auto_paginate
        pager = Pagination.new @last_response.headers

        while pager.more?
          opts[:params].update(pager.next_page_params)

          @last_response = request :get, opts
          pager          = Pagination.new @last_response.headers
          if block_given?
            yield(data, @last_response)
          else
            data.concat(@last_response.body) if @last_response.body.is_a?(Array)
          end
        end
      end

      data
    end

    # Get projects
    #
    # @param [Hash] params
    # @return [Array[TrackerApi::Resources::Project]]
    def projects(params={})
      Endpoints::Projects.new(self).get(params)
    end

    # Get project
    #
    # @param [Hash] params
    # @return [TrackerApi::Resources::Project]
    def project(id, params={})
      Endpoints::Project.new(self).get(id, params)
    end

    # Get information about the authenticated user
    #
    # @return [TrackerApi::Resources::Me]
    def me
      Endpoints::Me.new(self).get
    end

    # Get information about a client story without knowing what project the story belongs to
    #
    # @param [String] story_id
    # @return [TrackerApi::Resources::Story]
    def story(story_id)
      Endpoints::Story.new(self).get_story(story_id)
    end

    # Get notifications for the authenticated person
    #
    # @param [Hash] params
    # @return [Array[TrackerApi::Resources::Notification]]
    def notifications(params={})
      Endpoints::Notifications.new(self).get(params)
    end

    # Provides a list of all the activity performed the authenticated person.
    #
    # @param [Hash] params
    # @return [Array[TrackerApi::Resources::Activity]]
    def activity(params={})
      Endpoints::Activity.new(self).get(params)
    end

    private

    def parse_query_and_convenience_headers(path, options)
      raise 'Path can not be blank.' if path.to_s.empty?

      opts = { body: options[:body] }

      opts[:url]    = options[:url] || File.join(@url, @api_version, path.to_s)
      opts[:method] = options[:method] || :get
      opts[:params] = options[:params] || {}
      opts[:token]  = options[:token] || @token
      headers       = { 'User-Agent'     => USER_AGENT,
                        'X-TrackerToken' => opts.fetch(:token) }.merge(options.fetch(:headers, {}))

      CONVENIENCE_HEADERS.each do |h|
        if header = options[h]
          headers[h] = header
        end
      end
      opts[:headers] = headers

      opts
    end

    def request(method, options = {})
      url     = options.fetch(:url)
      params  = options[:params] || {}
      body    = options[:body]
      headers = options[:headers]

      if (method == :post || method == :put) && options[:body].blank?
        body                    = params.to_json
        headers['Content-Type'] = 'application/json'

        params = {}
      end

      @last_response = response = connection.send(method) do |req|
        req.url(url)
        req.headers.merge!(headers)
        req.params.merge!(params)
        req.body = body
      end
      response
    rescue Faraday::Error::ClientError => e
      raise TrackerApi::Error.new(e)
    end

    class Pagination
      attr_accessor :headers, :total, :limit, :offset, :returned

      def initialize(headers)
        @headers  = headers
        @total    = headers['x-tracker-pagination-total'].to_i
        @limit    = headers['x-tracker-pagination-limit'].to_i
        @offset   = headers['x-tracker-pagination-offset'].to_i
        @returned = headers['x-tracker-pagination-returned'].to_i

        # if offset is negative (e.g. Iterations Endpoint).
        #   For the 'Done' scope, negative numbers can be passed, which
        #   specifies the number of iterations preceding the 'Current' iteration.
        # then need to adjust the negative offset to account for a smaller total,
        #   and set total to zero since we are paginating from -X to 0.
        if @offset < 0
          @offset = -@total if @offset.abs > @total
          @total  = 0
        end
      end

      def more?
        (offset + limit) < total
      end

      def next_offset
        offset + limit
      end

      def next_page_params
        { limit: limit, offset: next_offset }
      end
    end
  end
end
