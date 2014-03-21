module TrackerApi
  class Logger < Faraday::Response::Middleware
    extend Forwardable

    def initialize(app, logger = nil)
      super(app)
      @logger = logger || ::Logger.new(STDOUT)
    end

    def_delegators :@logger, :debug, :info, :warn, :error, :fatal

    def call(env)
      info("#{env[:method]} => #{env[:url].to_s}")
      debug('request') { dump_headers env[:request_headers] }
      debug('request.body') { env[:body] }
      super
    end

    def on_complete(env)
      info("#{env[:status]} <= #{env[:url].to_s}")
      debug('response') { dump_headers env[:response_headers] }
      debug('response.body') { env[:body] }
    end

    private

    def dump_headers(headers)
      headers.map { |k, v| "#{k}: #{v.inspect}" }.join("\n")
    end
  end
end
