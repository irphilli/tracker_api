module TrackerApi
  module Endpoints
    class Blocker
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def create(project_id, story_id, params={})
        data = client.post("/projects/#{project_id}/stories/#{story_id}/blockers", params: params).body
        Resources::Blocker.new({ client: client, project_id: project_id }.merge(data))
      end

      def update(blocker, params={})
        raise ArgumentError, 'Valid blocker required to update.' unless blocker.instance_of?(Resources::Blocker)

        path = "/projects/#{blocker.project_id}/stories/#{blocker.story_id}/blockers/#{blocker.id}"
        data = client.put(path, params: params).body

        blocker.attributes = data
        blocker.clean!
        blocker
      end

      def delete(blocker)
        raise ArgumentError, 'Valid blocker required to update.' unless blocker.instance_of?(Resources::Blocker)

        client.delete("/projects/#{blocker.project_id}/stories/#{blocker.story_id}/blockers/#{blocker.id}").body
      end
    end
  end
end
