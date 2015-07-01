module TrackerApi
  module Resources
    class ProjectMembership
      include Shared::HasId

      attribute :person_id, Integer
      attribute :project_id, Integer
      attribute :role, String
      attribute :project_color, String
      attribute :wants_comment_notification_emails, Boolean
      attribute :kind, String
      attribute :person, Person
    end
  end
end
