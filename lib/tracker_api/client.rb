module TrackerApi
  class Client
    USER_AGENT = "Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}) TrackerApi/#{TrackerApi::VERSION} Faraday/#{Faraday::VERSION}".freeze

    attr_accessor :url, :api_version, :token, :logger, :connection

    # Create Pivotal Tracker API client.
    #
    # @param [Hash] options the connection options
    # @option options [String] :token API token to use for requests
    # @option options [String] :url Main HTTP API root
    # @option options [String] :api_version The API version URL path
    # @option options [String] :logger Custom logger
    # @option options [String] :adapter Custom http adapter to configure Faraday with
    # @option options [String] :connection_options Connection options to pass to Faraday
    #
    # @example Creating a Client
    #   Client.new token: 'my-super-special-token'
    def initialize(options={})
      url  = options[:url] || 'https://www.pivotaltracker.com'
      @url = URI.parse(url).to_s

      @api_version       = options[:api_version] || '/services/v5'
      @logger            = options[:logger] || Logger.new(nil)
      adapter            = options[:adapter] || :net_http
      connection_options = options[:connection_options] || { ssl: { verify: true } }
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

    def request(options={})
      method  = options[:method] || :get
      url     = options[:url] || File.join(@url, @api_version, options[:path])
      token   = options[:token] || @token
      params  = options[:params] || {}
      body    = options[:body]
      headers = { 'User-Agent' => USER_AGENT, 'X-TrackerToken' => token }.merge(options[:headers] || {})

      connection.send(method) do |req|
        req.url url
        req.headers.merge!(headers)
        req.params.merge!(params)
        req.body = body
      end
    rescue Faraday::Error::ClientError => e
      raise TrackerApi::Error.new(e)
    end

    def projects(params={})
      Endpoints::Projects.new(self).get(params)
    end

    def project(id, params={})
      Endpoints::Project.new(self).get(id, params)
    end
  end
end
