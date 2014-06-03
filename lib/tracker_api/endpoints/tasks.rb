module TrackerApi
  module Endpoints
    class Tasks
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, story_id,  params={})
        data = client.paginate("/projects/#{project_id}/stories/#{story_id}/tasks", params: params)
        raise TrackerApi::Errors::UnexpectedData, 'Array of tasks expected' unless data.is_a? Array

        data.map { |task| Resources::Task.new({ client: client }.merge(task)) }
      end
    end
  end
end
