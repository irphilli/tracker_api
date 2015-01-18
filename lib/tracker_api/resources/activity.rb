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
      attribute :primary_resources, Array[Hash]
      attribute :project_id, Integer
      attribute :project_version, Integer
    end
  end
end
