module TrackerApi
  module Endpoints
    class Search
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, query, options={})
        raise ArgumentError, 'Valid query string required to search' unless query.is_a?(String)

        options[:params] = { query: query }
        data = client.get("/projects/#{project_id}/search", options).body

        raise Errors::UnexpectedData, 'Hash of search results expect' unless data.is_a? Hash

        Resources::SearchResultContainer.new(data)
      end
    end
  end
end
