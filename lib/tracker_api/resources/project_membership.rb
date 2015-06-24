module TrackerApi
  module Resources
    class ProjectMembership
      include Resources::Base

      attribute :person_id, Integer
      attribute :project_id, Integer
      attribute :role, String
      attribute :project_color, String
      attribute :wants_comment_notification_emails, Boolean
      attribute :kind, String
      attribute :person, TrackerApi::Resources::Person
    end
  end
end
