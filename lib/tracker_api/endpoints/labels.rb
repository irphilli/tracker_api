module TrackerApi
  module Endpoints
    class Labels
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id)
        data = client.get("/projects/#{project_id}/labels").body
        raise TrackerApi::Errors::UnexpectedData, 'Array of labels expected' unless data.is_a? Array

        data.map do |label|
          Resources::Label.new({ client: client, project_id: project_id }.merge(label))
        end
      end
    end
  end
end
