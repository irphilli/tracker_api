module TrackerApi
  module Endpoints
    class Review
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def update(review, params = {})
        raise ArgumentError, 'Valid review required to update.' unless review.instance_of?(Resources::Review)

        data = client.put("/projects/#{review.project_id}/stories/#{review.story_id}/reviews/#{review.id}", params: params).body

        review.attributes = data
        review.clean!
        review
      end
    end
  end
end
