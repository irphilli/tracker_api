module TrackerApi
  module Resources
    class Release
      include Shared::Base

      attribute :client

      attribute :project_id, Integer
      attribute :name, String
      attribute :description, String
      attribute :current_state, String # (accepted, delivered, finished, started, rejected, planned, unstarted, unscheduled)
      attribute :accepted_at, DateTime
      attribute :deadline, DateTime
      attribute :labels, [Label]
      attribute :created_at, DateTime
      attribute :updated_at, DateTime
      attribute :url, String
      attribute :kind, String

      # Provides a list of all the stories in the release.
      #
      # @param [Hash] params
      # @return [Array[Story]] stories of this release
      def stories(params={})
        Endpoints::Stories.new(client).get_release(project_id, id, params)
      end
    end
  end
end
