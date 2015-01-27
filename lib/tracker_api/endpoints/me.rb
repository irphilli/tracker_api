module TrackerApi
  module Endpoints
    class Me
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get
        data = client.get("/me").body

        Resources::Me.new(data)
      end
    end
  end
end
