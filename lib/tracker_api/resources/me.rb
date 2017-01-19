module TrackerApi
  module Resources
    class Me < Resource
      attribute :name, Types::Coercible::String
      attribute :initials, Types::Coercible::String
      attribute :username, Types::Coercible::String
      # attribute :time_zone, TimeZone
      attribute :api_token, Types::Coercible::String
      attribute :has_google_identity, Types::Strict::Bool
      attribute :project_ids, Types::Strict::Array.member(Types::Coercible::Int)
      attribute :projects, Types::Strict::Array.member(MembershipSummary)
      attribute :workspace_ids, Types::Strict::Array.member(Types::Coercible::Int)
      # attribute :workspaces, Types::Strict::Array.member(Workspace)
      attribute :email, Types::Coercible::String
      attribute :receives_in_app_notifications, Types::Strict::Bool
      attribute :kind, Types::Coercible::String
    end
  end
end
