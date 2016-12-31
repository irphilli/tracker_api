module TrackerApi
  module Resources
    class Comment
      include Shared::Base

      attribute :client

      attribute :project_id, Integer
      attribute :story_id, Integer
      attribute :epic_id, Integer
      attribute :text, String
      attribute :person_id, Integer
      attribute :person, Person
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :file_attachment_ids, [Integer]
      attribute :google_attachment_ids, [Integer]
      attribute :commit_identifier, String
      attribute :commit_type, String
      attribute :kind, String

      class UpdateRepresenter < Representable::Decorator
        include Representable::JSON

        property :id
        property :text
      end

      def save
        raise ArgumentError, 'Cannot update a comment with an unknown story_id.' if story_id.nil?

        Endpoints::Comment.new(client).update(self, UpdateRepresenter.new(Comment.new(self.dirty_attributes)))
      end
    end
  end
end
