module TrackerApi
  module Resources
    class Epic
      include Shared::HasId

      attribute :client

      attribute :comment_ids, Array[Integer]
      attribute :comments, Array[Comment]
      attribute :created_at, DateTime
      attribute :description, String
      attribute :follower_ids, Array[Integer]
      attribute :followers, Array[Person]
      attribute :kind, String
      attribute :label, Label
      attribute :label_id, Integer
      attribute :name, String
      attribute :project_id, Integer
      attribute :updated_at, DateTime
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
    end
  end
end
