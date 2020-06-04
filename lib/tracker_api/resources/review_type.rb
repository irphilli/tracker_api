module TrackerApi
  module Resources
    class ReviewType
      include Shared::Base

      attribute :id, Integer
      attribute :project_id, Integer
      attribute :name, String
      attribute :hidden, Boolean
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :kind, String
    end
  end
end