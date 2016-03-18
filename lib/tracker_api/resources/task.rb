module TrackerApi
  module Resources
    class Task
      include Shared::Base

      attribute :client

      attribute :project_id, Integer
      attribute :story_id, Integer
      attribute :description, String
      attribute :complete, Boolean
      attribute :position, Integer
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :kind, String

      class UpdateRepresenter < Representable::Decorator
        include Representable::JSON

        property :id
        property :description
        property :complete
        property :position
      end

      def save
        raise ArgumentError, 'Cannot update a task with an unknown project_id.' if project_id.nil?
        raise ArgumentError, 'Cannot update a task with an unknown story_id.' if story_id.nil?

        Endpoints::Task.new(client).update(self, UpdateRepresenter.new(Task.new(self.dirty_attributes)))
      end
    end
  end
end
