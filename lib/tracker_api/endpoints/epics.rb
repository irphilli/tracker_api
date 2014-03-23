module TrackerApi
  module Endpoints
    class Epics
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, params={})
        data = client.request(
            method: :get,
            path:   "/projects/#{project_id}/epics",
            params: params
        ).body
        raise TrackerApi::Errors::UnexpectedData, 'Array of epics expected' unless data.is_a? Array

        data.map { |epic| Resources::Epic.new({ client: client }.merge(epic)) }
      end
    end
  end
end
