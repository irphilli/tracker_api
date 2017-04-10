module TrackerApi
  module Resources
    class StoriesSearchResult
      include Shared::Base

      attribute :stories, Array[Resources::Story]
      attribute :total_hits, Integer
      attribute :total_hits_with_done, Integer
      attribute :total_points, Float
      attribute :total_points_completed, Float
      attribute :kind, String
    end
  end
end
