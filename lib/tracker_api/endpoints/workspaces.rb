module TrackerApi
  module Endpoints
    class Workspaces
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(params={})
        data = client.paginate('/my/workspaces', params: params)
        raise Errors::UnexpectedData, 'Array of workspaces expected' unless data.is_a? Array

        data.map { |workspace| Resources::Workspace.new({ client: client }.merge(workspace))
        }
      end
    end
  end
end
