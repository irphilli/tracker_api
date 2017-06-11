module TrackerApi
  module Endpoints
    class Attachments
      attr_accessor :client

      def initialize(client)
        @client = client
      end


      def create(comment, files)
        return [] if files.to_a.empty?
        #Check files before upload to make it all or none.
        FileUtility.check_files_exist(files)
        attachment = Endpoints::Attachment.new(client)
        files.map do | file |
          attachment.create(comment, file)
        end  
      end
    end
  end
end
