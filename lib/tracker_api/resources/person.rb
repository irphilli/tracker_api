module TrackerApi
  module Resources
    class Person
      include Virtus.model

      attribute :kind, String
      attribute :id, Integer
      attribute :name, String
      attribute :email, String
      attribute :initials, String
      attribute :username, String
    end
  end
end
