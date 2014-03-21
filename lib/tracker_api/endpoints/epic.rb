module TrackerApi
  module Endpoints
    class Epic
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(params={})
        project_id = params.fetch('project_id')
        id         = params.fetch('id')

        data = client.request(
            :method => :get,
            :path   => "/projects/#{project_id}/epics/#{id}"
        ).body

        Resources::Epic.new({ client: client }.merge(data))
      end
    end
  end
end
