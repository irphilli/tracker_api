module TrackerApi
  module Resources
    class Blocker
      include Shared::Base

      attribute :client
      attribute :project_id, Integer

      attribute :story_id, Integer
      attribute :person_id, Integer
      attribute :description, String
      attribute :resolved, Boolean
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :kind, String
    end
  end
end
