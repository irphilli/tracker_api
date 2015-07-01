module TrackerApi
  module Resources
    class Me
      include Shared::HasId

      attribute :name, String
      attribute :initials, String
      attribute :username, String
      attribute :time_zone, TimeZone
      attribute :api_token, String
      attribute :has_google_identity, Boolean
      attribute :project_ids, Array[Integer]
      attribute :projects, [MembershipSummary]
      attribute :workspace_ids, Array[Integer]
      attribute :email, String
      attribute :receives_in_app_notifications, Boolean
      attribute :kind, String
    end
  end
end
