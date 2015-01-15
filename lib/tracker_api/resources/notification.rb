module TrackerApi
  module Resources
    class Notification
      include Virtus.model

      attribute :id, Integer
      attribute :message, String
      attribute :kind, String
      attribute :project, TrackerApi::Resources::Project
      attribute :story, TrackerApi::Resources::Story
      attribute :performer, TrackerApi::Resources::Person
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
    end
  end
end
