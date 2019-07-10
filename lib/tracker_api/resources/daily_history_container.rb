module TrackerApi
  module Resources
    class DailyHistoryContainer
      include Shared::Base

      attribute :project_id, Integer
      attribute :iteration_number, Integer
      attribute :header, [String]
      attribute :data, [Enumerable]
      attribute :kind, String
    end
  end
end
