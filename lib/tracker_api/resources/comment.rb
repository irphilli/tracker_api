module TrackerApi
  module Resources
    class Comment
      include Shared::Base

      attribute :story_id, Integer
      attribute :epic_id, Integer
      attribute :text, String
      attribute :person_id, Integer
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :file_attachment_ids, Shared::Collection[Integer]
      attribute :google_attachment_ids, Shared::Collection[Integer]
      attribute :commit_identifier, String
      attribute :commit_type, String
      attribute :kind, String
    end
  end
end
