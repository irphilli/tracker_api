module TrackerApi
  module Endpoints
    class Iteration
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(project_id, iteration_number)
        data = client.get("/projects/#{project_id}/iterations/#{iteration_number}").body

        Resources::Iteration.new({ client: client, project_id: project_id }.merge(data))
      end

      def get_analytics_cycle_time_details(project_id, iteration_number)
        data = client.paginate("/projects/#{project_id}/iterations/#{iteration_number}/analytics/cycle_time_details")
        raise Errors::UnexpectedData, 'Array of cycle time details expected' unless data.is_a? Array

        data.map do |cycle_time_details|
          Resources::CycleTimeDetails.new(
            { project_id: project_id, iteration_number: iteration_number }.merge(cycle_time_details)
          )
        end
      end

      def get_history(project_id, iteration_number)
        data = client.get("/projects/#{project_id}/history/iterations/#{iteration_number}/days").body
        raise Errors::UnexpectedData, 'Hash of history data expected' unless data.is_a? Hash

        Resources::DailyHistoryContainer.new({ project_id: project_id, iteration_number: iteration_number }.merge(data))
      end
    end
  end
end
