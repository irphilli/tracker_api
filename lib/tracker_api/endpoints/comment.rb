module TrackerApi
  module Endpoints
    class Comment
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def create(project_id, story_id: nil, epic_id: nil, params: {})
        raise ArgumentError, 'One of story id or epic id must be provided.' if story_id.nil? && epic_id.nil?

        comment_target_slug = !story_id.nil? ? "stories/#{story_id}" : "epics/#{epic_id}"

        data = client.post("/projects/#{project_id}/#{comment_target_slug}/comments", params: params).body
        Resources::Comment.new({ client: client, project_id: project_id }.merge(data))
      end

      def update(comment, params={})
        raise ArgumentError, 'Valid comment required to update.' unless comment.instance_of?(Resources::Comment)

        comment_target_slug = !comment.story_id.nil? ? "stories/#{comment.story_id}" : "epics/#{comment.epic_id}"

        path = "/projects/#{comment.project_id}/#{comment_target_slug}/comments/#{comment.id}"
        if params.represented.file_attachment_ids_to_add.present? || params.represented.file_attachment_ids_to_remove.present?
          path += "?fields=:default,file_attachments"
        end
        data = client.put(path, params: params).body

        comment.attributes = data
        comment.clean!
        comment
      end

      def delete(comment)
        raise ArgumentError, 'Valid comment required to update.' unless comment.instance_of?(Resources::Comment)

        comment_target_slug = !comment.story_id.nil? ? "stories/#{comment.story_id}" : "epics/#{comment.epic_id}"

        client.delete("/projects/#{comment.project_id}/#{comment_target_slug}/comments/#{comment.id}").body
      end
    end
  end
end
