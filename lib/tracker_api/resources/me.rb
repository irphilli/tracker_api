require_relative './shared/types'

module TrackerApi
  module Resources
    class Me < Shared::BaseDry
      attribute :name, Shared::Types::Coercible::String
      attribute :initials, Shared::Types::Coercible::String
      attribute :username, Shared::Types::Coercible::String
      # attribute :time_zone, TimeZone
      attribute :api_token, Shared::Types::Coercible::String
      attribute :has_google_identity, Shared::Types::Strict::Bool
      attribute :project_ids, Shared::Types::Strict::Array.member(Shared::Types::Coercible::Int)
      attribute :projects, Shared::Types::Strict::Array.member(MembershipSummary)
      attribute :workspace_ids, Shared::Types::Strict::Array.member(Shared::Types::Coercible::Int)
      # attribute :workspaces, Shared::Types::Strict::Array.member(Workspace)
      attribute :email, Shared::Types::Coercible::String
      attribute :receives_in_app_notifications, Shared::Types::Strict::Bool
      attribute :kind, Shared::Types::Coercible::String
    end
  end
end
