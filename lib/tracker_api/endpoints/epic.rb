module TrackerApi
  module Endpoints
    class Epic
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, id, params={})
        data = client.get("/projects/#{project_id}/epics/#{id}", params: params).body

        Resources::Epic.new({ client: client, project_id: project_id }.merge(data))
      end

      def create(project_id, params={})
        data = client.post("/projects/#{project_id}/epics", params: params).body

        Resources::Epic.new({ client: client }.merge(data))
      end

      def update(epic, params={})
        raise ArgumentError, 'Valid epic required to update.' unless epic.instance_of?(Resources::Epic)

        data = client.put("/projects/#{epic.project_id}/epics/#{epic.id}", params: params).body

        epic.attributes = data
      end
    end
  end
end
