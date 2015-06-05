module TrackerApi
  module Endpoints
    class Memberships
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, params={})
        data = client.paginate("/projects/#{project_id}/memberships", params: params)
        raise TrackerApi::Errors::UnexpectedData, 'Array of memberships expected' unless data.is_a? Array

        data.map do |membership|
          Resources::ProjectMembership.new({ project_id: project_id }.merge(membership))
        end
      end

      def add(project_id, params={})
        data = client.post("/projects/#{project_id}/memberships", params: params).body

        Resources::ProjectMembership.new({ project_id: project_id }.merge(data))
      end
    end
  end
end
