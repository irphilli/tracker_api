module TrackerApi
  module Resources
    class MembershipSummary
      include Shared::HasId

      attribute :kind, String
      attribute :last_viewed_at, DateTime
      attribute :project_color, String
      attribute :project_id, Integer
      attribute :project_name, String
      attribute :role, String
    end
  end
end
