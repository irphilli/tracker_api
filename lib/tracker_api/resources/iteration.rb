module TrackerApi
  module Resources
    class Iteration
      include Virtus.model

      attribute :client

      attribute :created_at, DateTime
      attribute :finish, DateTime
      attribute :id, Integer
      attribute :kind, String
      attribute :length, Integer
      attribute :number, Integer
      attribute :planned, Boolean
      attribute :project_id, Integer
      attribute :start, DateTime
      attribute :stories, [TrackerApi::Resources::Story]
      attribute :story_ids, [Integer]
      attribute :team_strength, Float
      attribute :updated_at, DateTime
    end
  end
end
