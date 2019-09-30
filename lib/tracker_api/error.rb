module TrackerApi
  class Error < StandardError
    attr_reader :wrapped_exception, :response

    def initialize(wrapped_exception)
      @wrapped_exception = wrapped_exception
      @response          = wrapped_exception.response
      message            = if wrapped_exception.is_a?(Faraday::ParsingError)
                             wrapped_exception.message
                           elsif faraday_response_error?(wrapped_exception)
                             wrapped_exception.response.inspect
                           else
                             wrapped_exception.instance_variable_get(:@wrapped_exception).inspect
                           end
      super(message)
    end

    private

    # faraday 16.0 re-organized their errors. The errors we're interested in,
    # Faraday::ClientError before 16.0 and Faraday::ServerError introduced in
    # 16.0, are represented by this conditional.
    def faraday_response_error?(wrapped_exception)
      wrapped_exception.is_a?(Faraday::Error) &&
        wrapped_exception.respond_to?(:response)
    end
  end
end
