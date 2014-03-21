module TrackerApi
  module Endpoints
    class Project
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(id, params={})
        data = client.request(
            method: :get,
            path:   "/projects/#{id}",
            params: params
        ).body

        Resources::Project.new({ client: client }.merge(data))
      end
    end
  end
end
