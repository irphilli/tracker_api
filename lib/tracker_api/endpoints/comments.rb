module TrackerApi
  module Endpoints
    class Comments
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, story_id: nil, epic_id: nil, params: {})
        raise ArgumentError, 'One of story id or epic id must be provided.' if story_id.nil? && epic_id.nil?

        comment_target_slug = !story_id.nil? ? "stories/#{story_id}" : "epics/#{epic_id}"

        data = client.paginate("/projects/#{project_id}/#{comment_target_slug}/comments", params: params)
        raise Errors::UnexpectedData, 'Array of comments expected' unless data.is_a? Array

        data.map do |comment|
          Resources::Comment.new({
            client: client,
            project_id: project_id
          }.merge(comment))
        end
      end
    end
  end
end
