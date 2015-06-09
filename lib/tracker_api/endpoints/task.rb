module TrackerApi
  module Endpoints
    class Task
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def create(project_id, story_id, params={})
        data = client.post("/projects/#{project_id}/stories/#{story_id}/tasks", params: params).body
        Resources::Task.new(data)
      end
    end
  end
end
