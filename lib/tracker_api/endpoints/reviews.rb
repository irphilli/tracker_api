module TrackerApi
  module Endpoints
    class Reviews
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, story_id, params={})
        params[:fields] ||= ":default,review_type"
        data = client.paginate("/projects/#{project_id}/stories/#{story_id}/reviews", params: params)
        raise Errors::UnexpectedData, 'Successful responses to this request return an array containing zero or more instances of the review resource. This response was not an array.' unless data.is_a? Array

        data.map do |review|
          Resources::Review.new({ client: client, project_id: project_id }.merge(review))
        end
      end
    end
  end
end