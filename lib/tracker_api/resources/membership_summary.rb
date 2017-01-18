require_relative './shared/types'

module TrackerApi
  module Resources
    class MembershipSummary < Shared::BaseDry
      attribute :kind, Shared::Types::Coercible::String
      attribute :last_viewed_at, Shared::Types::DateTime
      attribute :project_color, Shared::Types::Coercible::String
      attribute :project_id, Shared::Types::Coercible::Int
      attribute :project_name, Shared::Types::Coercible::String
      attribute :role, Shared::Types::Coercible::String
    end
  end
end
