module TrackerApi
  module Endpoints
    class Release
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, id, params={})
        data = client.get("/projects/#{project_id}/releases/#{id}", params: params).body

        Resources::Release.new({ client: client }.merge(data))
      end
    end
  end
end
