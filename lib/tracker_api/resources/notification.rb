module TrackerApi
  module Resources
    class Notification
      include Virtus.model

      attribute :id, Integer
      attribute :message, String
      attribute :kind, String
      attribute :project_id, Integer
      attribute :story_id, Integer
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
    end
  end
end
