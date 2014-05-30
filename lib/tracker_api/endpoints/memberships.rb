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

        data.map { |membership| Resources::ProjectMembership.new({ client: client }.merge(membership)) }
      end
    end
  end
end
