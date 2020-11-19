module TrackerApi
  module Resources
    class PullRequest
      include Shared::Base

      attribute :client

      attribute :id, Integer
      attribute :story_id, Integer
      attribute :epic_id, Integer
      attribute :owner, String
      attribute :repo, String
      attribute :number, Integer
      attribute :host_url, String
      attribute :original_url, String
      attribute :status, String
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :kind, String
    end
  end
end
