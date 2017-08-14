module TrackerApi
  module Resources
    class FileAttachment
      include Shared::Base

      attribute :comment, Comment

      attribute :id, Integer
      attribute :big_url, String
      attribute :content_type, String
      attribute :created_at, DateTime
      attribute :download_url, String
      attribute :filename, String
      attribute :height, Integer
      attribute :kind, String
      attribute :size, Integer
      attribute :thumbnail_url, String
      attribute :thumbnailable, Boolean
      attribute :uploaded, Boolean
      attribute :uploader_id, Integer
      attribute :width, Integer

      def delete
        comment.delete_attachments([id])
      end

      # TODO : Implement download properly. 
      # Look at Attchment#download for more details
      # The big_url actually has the AWS S3 link for the file
      # def download
      #   file_data = Endpoints::Attachment.new(comment.client).download(download_url)
      #   File.open(filename, 'wb') { |fp| fp.write(file_data) }
      # end
    end
  end
end

