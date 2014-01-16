module PivotalTracker
  class Client < Cistern::Service
    USER_AGENT = "Ruby/#{RUBY_VERSION} (#{RUBY_PLATFORM}; #{RUBY_ENGINE}) PivotalTracker/#{PivotalTracker::VERSION} Faraday/#{Faraday::VERSION}".freeze

    model_path "pivotal_tracker/client/models"
    request_path "pivotal_tracker/client/requests"

    collection :projects
    collection :epics
    collection :iterations
    #collection :stories

    model :project
    model :epic
    model :iteration
    #model :story

    request :get_projects
    request :get_epics
    request :get_iterations
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

    # Included to satisfy Cistern::Service requirements,
    # but using VCR instead of mocking for tests.
    class Mock
    end
  end
end
