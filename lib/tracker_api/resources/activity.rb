module TrackerApi
  module Resources
    class Activity
      include Virtus.model

      attribute :client

      attribute :kind, String
      attribute :guid, String
      attribute :project_version, Integer
      attribute :message, String
      attribute :highlight, String
      attribute :changes, Array[TrackerApi::Resources::Change]
      attribute :primary_resources, Array[TrackerApi::Resources::PrimaryResource]
      attribute :project, TrackerApi::Resources::Project
      attribute :performed_by, TrackerApi::Resources::Person
      attribute :occurred_at, DateTime

      def project=(data)
        super.client = client
      end
    end
  end
end
