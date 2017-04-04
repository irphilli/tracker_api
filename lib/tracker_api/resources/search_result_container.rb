module TrackerApi
  module Resources
    class SearchResultContainer
      include Shared::Base

      attribute :query, String
      attribute :stories, Resources::StoriesSearchResult
      attribute :epics, Resources::EpicsSearchResult
      attribute :kind, String
    end
  end
end
