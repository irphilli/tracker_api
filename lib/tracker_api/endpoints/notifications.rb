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
          Resources::Notification.new({ client: client }.merge(notification))
        end
      end
    end
  end
end
