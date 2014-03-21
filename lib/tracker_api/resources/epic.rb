module TrackerApi
  module Resources
    class Epic
      include Virtus.model

      attribute :id, Integer
      attribute :created_at, DateTime
      attribute :description, String
      attribute :kind, String
      attribute :label, TrackerApi::Resources::Label
      attribute :name, String
      attribute :project_id, Integer
      attribute :updated_at, DateTime
      attribute :url, String
    end
  end
end
