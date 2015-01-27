module TrackerApi
  module Endpoints
    class Epics
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, params={})
        data = client.paginate("/projects/#{project_id}/epics", params: params)
        raise TrackerApi::Errors::UnexpectedData, 'Array of epics expected' unless data.is_a? Array

        data.map do |epic|
          Resources::Epic.new({ project_id: project_id }.merge(epic))
        end
      end
    end
  end
end
