module TrackerApi
  module Endpoints
    class Stories
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, params={})
        url = params[:ids] ? "/projects/#{project_id}/stories/bulk" : "/projects/#{project_id}/stories"
        data = client.paginate(url, params: params)

        raise Errors::UnexpectedData, 'Array of stories expected' unless data.is_a? Array

        data.map do |story|
          Resources::Story.new({ client: client, project_id: project_id }.merge(story))
        end
      end
    end
  end
end
