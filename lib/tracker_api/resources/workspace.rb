module TrackerApi
  module Resources
    class Workspace
      include Shared::Base

      attribute :client

      attribute :person, Person
      attribute :person_id, Integer
      attribute :created_at, DateTime
      attribute :project_ids, [Integer]
      attribute :projects, [Project]
      attribute :kind, String
      attribute :name, String

    end
  end
end
