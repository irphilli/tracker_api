module TrackerApi
  module Resources
    class Activity
      include Virtus.model

      attribute :client

      attribute :changes, Array[TrackerApi::Resources::Change]
      attribute :guid, String
      attribute :highlight, String
      attribute :kind, String
      attribute :message, String
      attribute :occurred_at, DateTime
      attribute :performed_by_id, Integer
      attribute :performed_by, TrackerApi::Resources::Person
      attribute :primary_resources, Array[Hash]
      attribute :project_id, Integer
      attribute :project, TrackerApi::Resources::Project
      attribute :project_version, Integer

      def project=(data)
        super.client = client
      end
    end
  end
end
