module TrackerApi
  module Endpoints
    class Comment
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def create(project_id, story_id, params={})
        data = client.post("/projects/#{project_id}/stories/#{story_id}/comments", params: params).body
        Resources::Comment.new({ client: client, project_id: project_id }.merge(data))
      end

      def update(comment, params={})
        raise ArgumentError, 'Valid comment required to update.' unless comment.instance_of?(Resources::Comment)

        data = client.put("/projects/#{comment.project_id}/stories/#{comment.story_id}/comments/#{comment.id}",
                          params: params).body

        comment.attributes = data
        comment.clean!
        comment
      end
    end
  end
end
