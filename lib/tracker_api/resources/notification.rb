module TrackerApi
  module Resources
    class Notification
      include Virtus.model

      attribute :client

      attribute :id, Integer
      attribute :message, String
      attribute :kind, String
      attribute :project, TrackerApi::Resources::Project
      attribute :story, TrackerApi::Resources::Story
      attribute :performer, TrackerApi::Resources::Person
      attribute :created_at, DateTime
      attribute :updated_at, DateTime

      def project=(data)
        super.client = client
      end

      def story=(data)
        super.client = client
      end
    end
  end
end
