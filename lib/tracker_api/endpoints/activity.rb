module TrackerApi
  module Endpoints
    class Activity
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, story_id=nil, params={})
        target_url = story_id ? "/projects/#{project_id}/stories/#{story_id}/activity" : "/projects/#{project_id}/activity"
        data = client.paginate(target_url, params: params)
        raise TrackerApi::Errors::UnexpectedData, 'Array of activities expected' unless data.is_a? Array

        data.map do |activity|
          Resources::Activity.new({ client: client, project_id: project_id }.merge(activity))
        end
      end
    end
  end
end
