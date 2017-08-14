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

        path = "/projects/#{comment.project_id}/stories/#{comment.story_id}/comments/#{comment.id}"
        path += "?fields=:default,file_attachments" if params.represented.file_attachment_ids_to_add.present? || params.represented.file_attachment_ids_to_remove.present?
        data = client.put(path, params: params).body

        comment.attributes = data
        comment.clean!
        comment
      end

      def delete(comment)
        raise ArgumentError, 'Valid comment required to update.' unless comment.instance_of?(Resources::Comment)

        client.delete("/projects/#{comment.project_id}/stories/#{comment.story_id}/comments/#{comment.id}").body
      end
    end
  end
end
