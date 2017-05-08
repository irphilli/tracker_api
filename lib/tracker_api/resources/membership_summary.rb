module TrackerApi
  module Resources
    class MembershipSummary < Resource
      attribute :kind, Types::Coercible::String
      attribute :last_viewed_at, Types::DateTime
      attribute :project_color, Types::Coercible::String
      attribute :project_id, Types::Coercible::Int
      attribute :project_name, Types::Coercible::String
      attribute :role, Types::Coercible::String
    end
  end
end
