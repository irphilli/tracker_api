module TrackerApi
  module Resources
    class Iteration
      include Virtus.model
      include Equalizer.new(:number, :project_id)

      attribute :client

      attribute :finish, DateTime
      attribute :kind, String
      attribute :length, Integer
      attribute :number, Integer
      attribute :planned, Boolean
      attribute :project_id, Integer
      attribute :start, DateTime
      attribute :stories, [Story]
      attribute :story_ids, [Integer]
      attribute :team_strength, Float
      attribute :velocity, Float
      attribute :points, Integer
      attribute :accepted_points, Integer
      attribute :effective_points, Float

      def stories=(data)
        super.each { |s| s.client = client }
      end

      # Provides a list of all the cycle_time_details of each story in the iteration.
      #
      # @return [Array[CycleTimeDetails]] array of cycle_time_details of iterations in this project
      def cycle_time_details
        Endpoints::Iteration.new(client).get_analytics_cycle_time_details(project_id, number)
      end

      # Returns per day information of story points and counts by state for the given iteration.
      #
      # @return [DailyHistoryContainer]
      def get_history
        Endpoints::Iteration.new(client).get_history(project_id, number)
      end
    end
  end
end
