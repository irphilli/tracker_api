module TrackerApi
  module Endpoints
    class Stories
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, params={})
        data = client.request(
            method: :get,
            path:   "/projects/#{project_id}/stories",
            params: params
        ).body
        raise TrackerApi::Errors::UnexpectedData, 'Array of stories expected' unless data.is_a? Array

        data.map { |story| Resources::Story.new({ client: client }.merge(story)) }
      end
    end
  end
end
