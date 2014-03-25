module TrackerApi
  module Endpoints
    class Story
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, id)
        data = client.get("/projects/#{project_id}/stories/#{id}").body

        Resources::Story.new({ client: client }.merge(data))
      end
    end
  end
end
