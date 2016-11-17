module TrackerApi
  module Endpoints
    class Webhook
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, id, params={})
        data = client.get("/projects/#{project_id}/webhooks/#{id}", params: params).body

        Resources::Webhook.new({ client: client, project_id: project_id }.merge(data))
      end

      def create(project_id, params={})
        data = client.post("/projects/#{project_id}/webhooks", params: params).body

        Resources::Webhook.new({ client: client }.merge(data))
      end

      def update(webhook, params={})
        raise ArgumentError, 'Valid webhook required to update.' unless webhook.instance_of?(Resources::Webhook)

        data = client.put("/projects/#{webhook.project_id}/webhooks/#{webhook.id}", params: params).body

        webhook.attributes = data
        webhook.clean!
        webhook
      end

      def delete(webhook)
        raise ArgumentError, 'Valid webhook required to update.' unless webhook.instance_of?(Resources::Webhook)

        data = client.delete("/projects/#{webhook.project_id}/webhooks/#{webhook.id}")
        data.status == 204
      end

      def delete_from_project(project_id, webhook_id)
        data = client.delete("/projects/#{project_id}/webhooks/#{webhook_id}")
        data.status == 204
      end
    end
  end
end
