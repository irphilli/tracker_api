module PivotalTracker
  class Client < Cistern::Service
    USER_AGENT = "Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}) PivotalTracker/#{PivotalTracker::VERSION} Faraday/#{Faraday::VERSION}".freeze

    model_path "pivotal_tracker/client/models"
    request_path "pivotal_tracker/client/requests"

    collection :projects
    collection :epics
    #collection :stories

    model :project
    model :epic
    #model :story

    request :get_projects
    request :get_epics
    #request :get_stories

    request :get_project
    request :get_epic
    #request :get_story

    recognizes :url, :api_version, :path, :logger, :adapter, :token

    class Real
      attr_accessor :url, :api_version, :token, :logger

      def initialize(options={})
        url = options[:url] || PivotalTracker.defaults[:url] || 'https://www.pivotaltracker.com'

        @url = URI.parse(url).to_s

        @api_version       = options[:api_version] || PivotalTracker.defaults[:api_version] || "/services/v5"
        @logger            = options[:logger] || Logger.new(nil)
        adapter            = options[:adapter] || :net_http
        connection_options = options[:connection_options] || { ssl: { verify: true } }
        @token             = options[:token] || PivotalTracker.defaults[:token]

        raise "Missing required options: :token" unless @token

        @connection = Faraday.new({ url: @url }.merge(connection_options)) do |builder|
          # response
          builder.use Faraday::Response::RaiseError
          builder.response :json

          # request
          builder.request :multipart
          builder.request :json

          builder.use PivotalTracker::Logger, @logger
          builder.adapter adapter
        end
      end

      def request(options={})
        method  = options[:method] || :get
        url     = options[:url] || File.join(@url, @api_version, options[:path])
        token   = options[:token] || @token
        params  = options[:params] || {}
        body    = options[:body]
        headers = { "User-Agent" => USER_AGENT, "X-TrackerToken" => token }.merge(options[:headers] || {})

        @connection.send(method) do |req|
          req.url url
          req.headers.merge!(headers)
          req.params.merge!(params)
          req.body = body
        end
      rescue Faraday::Error::ClientError => e
        raise PivotalTracker::Error.new(e)
      end
    end

    class Mock
      attr_reader :url, :token

      def self.data
        @data ||= {
            :projects => {},
            :epics    => {},
            :stories  => {},
        }
      end

      def self.new_id
        @current_id ||= 0
        @current_id += 1
      end

      def data
        self.class.data
      end

      def self.reset!
        @data = nil
      end

      def initialize(options={})
        url = options[:url] || 'http://mock.pivotaltracker.com'

        @url                 = url
        @path                = URI.parse(url).path
        @token               = options[:token]
      end

      def url_for(path)
        File.join(@url, "/services/v5", path.to_s)
      end

      #def page(params, collection, path, collection_root, options={})
      #  page_params = PivotalTracker.paging_parameters(params)
      #  page_size   = (page_params["per_page"] || 50).to_i
      #  page_index  = (page_params["page"] || 1).to_i
      #  offset      = (page_index - 1) * page_size
      #  filter      = options[:filter]
      #  resources   = self.data[collection].values
      #  resources   = filter.call(resources) if filter
      #  count       = resources.size
      #  total_pages = (count / page_size) + 1
      #
      #  next_page     = if page_index < total_pages
      #                    url_for("#{path}?page=#{page_index + 1}&per_page=#{page_size}")
      #                  end
      #  previous_page = if page_index > 1
      #                    url_for("#{path}?page=#{page_index - 1}&per_page=#{page_size}")
      #                  end
      #
      #  resource_page = resources.slice(offset, page_size)
      #
      #  body = {
      #      collection_root => resource_page,
      #      "count"         => count,
      #      "next_page"     => next_page,
      #      "previous_page" => previous_page,
      #  }
      #
      #  response(
      #      :body => body,
      #      :path => path
      #  )
      #end

      def pluralize(word)
        pluralized = word.dup
        [[/y$/, 'ies'], [/$/, 's']].find { |regex, replace| pluralized.gsub!(regex, replace) if pluralized.match(regex) }
        pluralized
      end

      def response(options={})
        method = options[:method] || :get
        status = options[:status] || 200
        path   = options[:path]
        body   = options[:body]

        url = options[:url] || url_for(path)

        env = {
            :method           => method,
            :status           => status,
            :url              => url,
            :body             => body,
            :response_headers => {
                "Content-Type" => "application/json; charset=utf-8"
            },
        }
        Faraday::Response::RaiseError.new.on_complete(env) || Faraday::Response.new(env)
      rescue Faraday::Error::ClientError => e
        raise PivotalTracker::Error.new(e)
      end
    end
  end
end
