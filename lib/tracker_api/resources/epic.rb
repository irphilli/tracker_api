module TrackerApi
  module Resources
    class Epic
      include Shared::Base

      attribute :client

      attribute :comment_ids, [Integer]
      attribute :comments, [Comment]
      attribute :created_at, DateTime
      attribute :description, String
      attribute :follower_ids, [Integer]
      attribute :followers, [Person]
      attribute :kind, String
      attribute :label, Label
      attribute :label_id, Integer
      attribute :name, String
      attribute :project_id, Integer
      attribute :updated_at, DateTime
      attribute :completed_at, DateTime
      attribute :projected_completion, DateTime
      attribute :url, String

      class UpdateRepresenter < Representable::Decorator
        include Representable::JSON

        property :name
        property :description
        property :label, class: Label, decorator: Label::UpdateRepresenter, render_empty: true
      end

      # Save changes to an existing Epic.
      def save
        raise ArgumentError, 'Can not update an epic with an unknown project_id.' if project_id.nil?

        Endpoints::Epic.new(client).update(self, UpdateRepresenter.new(self))
      end

      # Provides a list of all the comments on the epic.
      def comments(reload: false)
        if !reload && @comments.present?
          @comments
        else
          @comments = Endpoints::Comments.new(client).get(project_id, epic_id: id)
        end
      end

      # @param [Hash] params attributes to create the comment with
      # @return [Comment] newly created Comment
      def create_comment(params)
        files = params.delete(:files)
        comment = Endpoints::Comment.new(client).create(project_id, epic_id: id, params: params)
        comment.create_attachments(files: files) if files.present?
        comment
      end
    end
  end
end
