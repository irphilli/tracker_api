module TrackerApi
  module Endpoints
    class Notifications
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(params={})
        data = client.paginate('/my/notifications', params: params)
        raise TrackerApi::Errors::UnexpectedData, 'Array of notifications expected' unless data.is_a? Array

        data.map do |notification|
          Resources::Notification.new({ client: client }.merge(notification))
        end
      end
    end
  end
end
