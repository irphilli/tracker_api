module TrackerApi
  module Resources
    class Blocker
      include Shared::Base

      attribute :client

      attribute :project_id, Integer
      attribute :story_id, Integer
      attribute :description, String
      attribute :resolved, Boolean
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :kind, String

      class UpdateRepresenter < Representable::Decorator
        include Representable::JSON

        property :id
        property :description
      end

      def save
        raise ArgumentError, 'Cannot update a blcoker with an unknown story_id.' if story_id.nil?

        Endpoints::Blocker.new(client).update(self, UpdateRepresenter.new(Blocker.new(self.dirty_attributes)))
      end

      def delete
        raise ArgumentError, 'Cannot delete a blcoker with an unknown story_id.' if story_id.nil?

        Endpoints::Blocker.new(client).delete(self)
      end
    end
  end
end
