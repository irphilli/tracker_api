module TrackerApi
  module Resources
    class Account
      include Virtus.model

      attribute :id, Integer
      attribute :created_at, DateTime
      attribute :status, String
      attribute :kind, String
      attribute :name, String
      attribute :updated_at, DateTime
      attribute :url, String
      attribute :plan, String
      attribute :days_left, Integer
      attribute :over_the_limit, Boolean
    end
  end
end
