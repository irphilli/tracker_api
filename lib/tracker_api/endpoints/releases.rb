module TrackerApi
  module Endpoints
    class Releases
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, params={})
        data = client.paginate("/projects/#{project_id}/releases", params: params)
        raise Errors::UnexpectedData, 'Array of releases expected' unless data.is_a? Array

        data.map do |release|
          Resources::Release.new({ client: client, project_id: project_id }.merge(release))
        end
      end
    end
  end
end