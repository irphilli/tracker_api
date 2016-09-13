module TrackerApi
  module Endpoints
    class Workspace
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(id, params={})
        data = client.get("/my/workspaces/#{id}", params: params).body

        Resources::Workspace.new({ client: client }.merge(data))
      end

      def create(params={})
        data = client.post("/my/workspaces", params: params).body

        Resources::Workspace.new({ client: client }.merge(data))
      end
    end
  end
end
