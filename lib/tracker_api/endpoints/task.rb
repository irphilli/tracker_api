module TrackerApi
  module Endpoints
    class Task
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def create(project_id, story_id, params={})
        data = client.post("/projects/#{project_id}/stories/#{story_id}/tasks", params: params).body
        Resources::Task.new({ client: client }.merge(data))
      end

      def update(task, params={})
        raise ArgumentError, 'Valid task required to update.' unless task.instance_of?(Resources::Task)

        data = client.put("/projects/#{task.project_id}/stories/#{task.story_id}/tasks/#{task.id}",
                          params: params).body

        task.attributes = data
        task.clean!
        task
      end
    end
  end
end
