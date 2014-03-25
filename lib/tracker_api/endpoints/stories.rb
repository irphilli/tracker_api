module TrackerApi
  module Endpoints
    class Stories
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, params={})
        data = client.paginate("/projects/#{project_id}/stories", params: params)
        raise TrackerApi::Errors::UnexpectedData, 'Array of stories expected' unless data.is_a? Array

        data.map { |story| Resources::Story.new({ client: client }.merge(story)) }
      end
    end
  end
end
