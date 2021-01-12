module TrackerApi
  module Resources
    class Review
      include Shared::Base

      attribute :client

      attribute :id, Integer
      attribute :story_id, Integer
      attribute :project_id, Integer
      attribute :review_type_id, Integer
      attribute :reviewer_id, Integer
      attribute :status, String # (unstarted, in_review, pass, revise)
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :kind, String
      attribute :review_type, ReviewType

      class UpdateRepresenter < Representable::Decorator
        include Representable::JSON

        property :id
        property :review_type_id
        property :reviewer_id
        property :status
      end

      def save
        raise ArgumentError, 'Cannot update a review with an unknown story_id.' if story_id.nil?

        Endpoints::Review.new(client).update(self, UpdateRepresenter.new(Review.new(dirty_attributes)))
      end
    end
  end
end
