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

      def stories=(data)
        super.each { |s| s.client = client }
      end
    end
  end
end
