module TrackerApi
  module Resources
    class PrimaryResource
      include Resources::Base

      attribute :kind, String
      attribute :name, String
      attribute :story_type, String
      attribute :url, String
    end
  end
end