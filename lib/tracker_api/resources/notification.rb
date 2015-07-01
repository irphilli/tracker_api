module TrackerApi
  module Resources
    class Notification
      include Shared::HasId

      attribute :client

      attribute :message, String
      attribute :kind, String
      attribute :project, Project
      attribute :story, Story
      attribute :performer, Person
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
