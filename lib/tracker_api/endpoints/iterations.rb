module TrackerApi
  module Endpoints
    class Iterations
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, params={})
        data = client.request(
            method: :get,
            path:   "/projects/#{project_id}/iterations",
            params: params
        ).body
        raise TrackerApi::Errors::UnexpectedData, 'Array of iterations expected' unless data.is_a? Array

        data.map { |iteration| Resources::Iteration.new({ client: client }.merge(iteration)) }
      end
    end
  end
end
