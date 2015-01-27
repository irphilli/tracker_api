module TrackerApi
  module Resources
    class Me
      include Virtus.model

      attribute :id, Integer
      attribute :name, String
      attribute :initials, String
      attribute :username, String
      attribute :time_zone, TrackerApi::Resources::TimeZone
      attribute :api_token, String
      attribute :has_google_identity, Boolean
      attribute :project_ids, Array[Integer]
      attribute :projects, [TrackerApi::Resources::MembershipSummary]
      attribute :workspace_ids, Array[Integer]
      attribute :email, String
      attribute :receives_in_app_notifications, Boolean
      attribute :kind, String
    end
  end
end
