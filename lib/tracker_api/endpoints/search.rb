module TrackerApi
  module Endpoints
    class Search
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, query, params={})
        raise ArgumentError, 'Valid query required to search' unless query.is_a?(String)

        params.key?(:body) ? params[:body][:query] = query : params[:body] = { query: query }
        data = client.paginate("/projects/#{project_id}/search", params)

        raise Errors::UnexpectedData, 'Hash of search results expect' unless data.is_a? Hash

        create_search_results(data)
      end

      private

      def create_search_results(data)
        epic_results     = create_epic_results(data.delete('epics'))
        story_results    = create_story_results(data.delete('stories'))

        Resources::SearchResultContainer.new(
          query: data.delete('query'),
          epics: epic_results,
          stories: story_results
        )
      end

      def create_epic_results(epics)
        Resources::EpicsSearchResult.new(
          epics: epics['epics'],
          total_hits: epics['total_hits'],
          total_hits_with_done: epics['total_hits_with_done']
        )
      end

      def create_story_results(stories)
        Resources::StoriesSearchResult.new(
          stories: stories['stories'],
          total_hits: stories['total_hits'],
          total_hits_with_done: stories['total_hits_with_done'],
          total_points: stories['total_points'],
          total_points_completed: stories['total_points_completed']
        )
      end
    end
  end
end
