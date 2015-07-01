module TrackerApi
  module Resources
    class Epic
      include Shared::HasId

      attribute :comment_ids, Array[Integer]
      attribute :comments, Array[Comment]
      attribute :created_at, DateTime
      attribute :description, String
      attribute :follower_ids, Array[Integer]
      attribute :followers, Array[Person]
      attribute :kind, String
      attribute :label, Label
      attribute :label_id, Integer
      attribute :name, String
      attribute :project_id, Integer
      attribute :updated_at, DateTime
      attribute :url, String
    end
  end
end
