module TrackerApi
  module Resources
    class EpicsSearchResult
      include Shared::Base

      attribute :epics, Array[Resources::Epic]
      attribute :total_hits, Integer
      attribute :total_hits_with_done, Integer
      attribute :kind, String
    end
  end
end
