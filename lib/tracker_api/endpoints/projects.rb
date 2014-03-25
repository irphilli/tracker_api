module TrackerApi
  module Endpoints
    class Projects
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(params={})
        data = client.paginate('/projects', params: params)
        raise TrackerApi::Errors::UnexpectedData, 'Array of projects expected' unless data.is_a? Array

        data.map { |project| Resources::Project.new({ client: client }.merge(project)) }
      end
    end
  end
end
