module TrackerApi
  module Resources
    class Task
      include Shared::HasId

      attribute :story_id, Integer
      attribute :description, String
      attribute :complete, Boolean
      attribute :position, Integer
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :kind, String
    end
  end
end
