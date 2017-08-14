module TrackerApi
  module Endpoints
    class Attachment
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def create(comment, file)
        data = client.post("/projects/#{comment.project_id}/uploads", body: FileUtility.get_file_upload(file)).body
        Resources::FileAttachment.new({ comment: comment }.merge(data))
      end

      # TODO : Discuss before implementing this as it orphans the file.
      # It deletes source, but the file name appears in the comments
      # def delete(comment, file_attachment_id)
      #   client.delete("/projects/#{comment.project_id}/stories/#{comment.story_id}/comments/#{comment.id}/file_attachments/#{file_attachment_id}").body
      # end

      def get(comment)
        data = client.get("/projects/#{comment.project_id}/stories/#{comment.story_id}/comments/#{comment.id}?fields=file_attachments").body["file_attachments"]
        raise Errors::UnexpectedData, 'Array of file attachments expected' unless data.is_a? Array

        data.map do |file_attachment|
          Resources::FileAttachment.new({ comment: comment }.merge(file_attachment))
        end
      end

      # TODO : Implement this properly.
      # This results in either content of the file or an S3 link.
      # the S3 link is also present in big_url attribute.
      # def download(download_path)
      #   client.get(download_path, url: '').body
      # end
    end
  end
end
