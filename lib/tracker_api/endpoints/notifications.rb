module TrackerApi
  module Endpoints
    class Notifications
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(params={})
        data = client.paginate("/my/notifications")
        data.map do |notification|
          Resources::Notification.new({ client: client,
                                        story_id: notification['story']['id'],
                                        project_id: notification['project']['id'] }.merge(notification))
        end
      end
    end
  end
end
