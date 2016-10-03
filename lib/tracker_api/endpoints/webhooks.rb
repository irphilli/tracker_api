module TrackerApi
  module Endpoints
    class Webhooks
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, params={})
        data = client.paginate("/projects/#{project_id}/webhooks", params: params)
        raise Errors::UnexpectedData, 'Array of webhooks expected' unless data.is_a? Array

        data.map do |webhook|
          Resources::Webhook.new({ client: client, project_id: project_id }.merge(webhook))
        end
      end
    end
  end
end
