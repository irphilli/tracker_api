module TrackerApi
  module Endpoints
    class Blockers
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, story_id, params = {})
        data = client.get("/projects/#{project_id}/stories/#{story_id}/blockers", params: params).body
        raise Errors::UnexpectedData, 'Array of Blockers expected' unless data.is_a? Array

        data.map do |blocker|
          Resources::Blocker.new({ client: client, project_id: project_id }.merge(blocker))
        end
      end
    end
  end
end
