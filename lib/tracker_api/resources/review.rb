module TrackerApi
  module Resources
    class Review
      include Shared::Base

      attribute :client

      attribute :id, Integer
      attribute :story_id, Integer
      attribute :review_type_id, Integer
      attribute :reviewer_id, Integer
      attribute :status, String # (unstarted, in_review, pass, revise)
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :kind, String
      attribute :review_type, ReviewType
    end
  end
end