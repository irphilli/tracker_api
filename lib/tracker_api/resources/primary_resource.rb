module TrackerApi
  module Resources
    class PrimaryResource
      include Virtus.model

      attribute :id, Integer
      attribute :kind, String
      attribute :name, String
      attribute :story_type, String
      attribute :url, String
    end
  end
end