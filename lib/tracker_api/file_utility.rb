module TrackerApi
  class FileUtility
    class << self
      def get_file_upload(file)
        mime_type = MiniMime.lookup_by_filename(file)
        { :file => Faraday::UploadIO.new(file, mime_type) }
      end

      def check_files_exist(files)
        files.each do | file |
          raise ArgumentError, 'Attachment file not found.' unless Pathname.new(file).exist?
        end    
      end
    end
  end
end