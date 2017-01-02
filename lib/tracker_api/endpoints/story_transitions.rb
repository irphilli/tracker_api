module TrackerApi
  module Endpoints
    class StoryTransitions
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, story_id, params={})
        data = client.paginate("/projects/#{project_id}/stories/#{story_id}/transitions", params: params)
        raise Errors::UnexpectedData, 'Array of story transitions expected' unless data.is_a? Array

        data.map do |transition|
          Resources::StoryTransition.new(transition)
        end
      end
    end
  end
end