module TrackerApi
  module Resources
    class Person
      include Shared::Base

      attribute :kind, String
      attribute :name, String
      attribute :email, String
      attribute :initials, String
      attribute :username, String
    end
  end
end
