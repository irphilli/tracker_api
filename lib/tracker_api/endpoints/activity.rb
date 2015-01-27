module TrackerApi
  module Endpoints
    class Activity
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(params={})
        data = client.paginate("/my/activity", params: params)
        raise TrackerApi::Errors::UnexpectedData, 'Array of activities expected' unless data.is_a? Array

        data.map do |activity|
          Resources::Activity.new({ client: client }.merge(activity))
        end
      end

      def get_project(project_id, params={})
        data = client.paginate("/projects/#{project_id}/activity", params: params)
        raise TrackerApi::Errors::UnexpectedData, 'Array of activities expected' unless data.is_a? Array

        data.map do |activity|
          Resources::Activity.new({ client: client }.merge(activity))
        end
      end

      def get_story(project_id, story_id, params={})
        data = client.paginate("/projects/#{project_id}/stories/#{story_id}/activity", params: params)
        raise TrackerApi::Errors::UnexpectedData, 'Array of activities expected' unless data.is_a? Array

        data.map do |activity|
          Resources::Activity.new({ client: client }.merge(activity))
        end
      end
    end
  end
end
