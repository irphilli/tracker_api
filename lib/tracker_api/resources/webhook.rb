module TrackerApi
  module Resources
    class Webhook
      include Shared::Base

      attribute :client

      attribute :kind, String
      attribute :project_id, Integer
      attribute :webhook_url, String
      attribute :webhook_version, String
      attribute :created_at, DateTime
      attribute :updated_at, DateTime

      class UpdateRepresenter < Representable::Decorator
        include Representable::JSON

        property :project_id
        property :webhook_url
        property :webhook_version
      end

      def delete
        raise ArgumentError, 'Can not delete a webhook with an unknown project_id.' if project_id.nil?

        Endpoints::Webhook.new(client).delete(self)
      end

      # Save changes to an existing Webhook.
      def save
        raise ArgumentError, 'Can not update a webhook with an unknown project_id.' if project_id.nil?

        Endpoints::Webhook.new(client).update(self, UpdateRepresenter.new(Webhook.new(self.dirty_attributes)))
      end
    end
  end
end
