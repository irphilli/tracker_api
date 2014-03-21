module TrackerApi
  module Resources
    class Label
      include Virtus.model

      attribute :id, Integer
      attribute :created_at, DateTime
      attribute :kind, String
      attribute :name, String
      attribute :project_id, Integer
      attribute :updated_at, DateTime
    end
  end
end
