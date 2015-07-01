module TrackerApi
  module Resources
    class Label
      include Shared::HasId

      attribute :created_at, DateTime
      attribute :kind, String
      attribute :name, String
      attribute :project_id, Integer
      attribute :updated_at, DateTime

      class UpdateRepresenter < Representable::Decorator
        include Representable::JSON

        property :id
        property :name
      end
    end
  end
end
