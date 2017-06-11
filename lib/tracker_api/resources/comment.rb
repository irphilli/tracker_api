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
      attribute :file_attachments, [FileAttachment]
      attribute :google_attachment_ids, [Integer]
      attribute :file_attachment_ids_to_add, [Integer]
      attribute :file_attachment_ids_to_remove, [Integer]
      attribute :commit_identifier, String
      attribute :commit_type, String
      attribute :kind, String

      class UpdateRepresenter < Representable::Decorator
        include Representable::JSON

        property :id
        property :text
        collection :file_attachment_ids_to_add
        collection :file_attachment_ids_to_remove
      end

      def save
        raise ArgumentError, 'Cannot update a comment with an unknown story_id.' if story_id.nil?

        Endpoints::Comment.new(client).update(self, UpdateRepresenter.new(Comment.new(self.dirty_attributes)))
      end

      def delete
        raise ArgumentError, 'Cannot delete a comment with an unknown story_id.' if story_id.nil?

        Endpoints::Comment.new(client).delete(self)
      end

      # @param [Hash] params attributes to create the comment with
      # @return [Comment] newly created Comment
      def create_attachments(params)
        self.file_attachment_ids_to_add = Endpoints::Attachments.new(client).create(self, params[:files]).collect(&:id)
        save
      end

      def delete_attachments(attachment_ids = nil)
        self.file_attachment_ids_to_remove = attachment_ids || attachments.collect(&:id)
        save
      end

      # Provides a list of all the attachments on the comment.
      #
      # @reload Boolean to reload the attachments
      # @return [Array[FileAttachments]]
      def attachments(reload: false)
        if !reload && @file_attachments.present?
          @file_attachments
        else
          @file_attachments = Endpoints::Attachment.new(client).get(self)
        end
      end
    end
  end
end
