module TrackerApi
  module Resources
    class CycleTimeDetails
      include Shared::Base

      attribute :project_id, Integer
      attribute :iteration_number, Integer
      attribute :total_cycle_time, Integer
      attribute :started_time, Integer
      attribute :started_count, Integer
      attribute :finished_time, Integer
      attribute :finished_count, Integer
      attribute :delivered_time, Integer
      attribute :delivered_count, Integer
      attribute :rejected_time, Integer
      attribute :rejected_count, Integer
      attribute :story_id, Integer
      attribute :kind, String
    end
  end
end
