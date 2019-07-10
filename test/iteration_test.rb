require_relative 'minitest_helper'

describe TrackerApi::Resources::Iteration do
  let(:pt_user) { PT_USER_1 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }
  let(:project_id) { pt_user[:project_id] }
  let(:project) { VCR.use_cassette('get project') { client.project(project_id) } }
  let(:iteration) { VCR.use_cassette('get current iteration') { project.iterations(scope: "current").first } }

  describe "#cycle_time_details" do
    it "gets all cycle_time_details for this iteration" do
      VCR.use_cassette('get cycle time details', record: :new_episodes) do
        cycle_time_details = iteration.cycle_time_details

        cycle_time_details.wont_be_empty
        cycle_time_detail = cycle_time_details.first
        cycle_time_detail.must_be_instance_of TrackerApi::Resources::CycleTimeDetails
      end
    end
  end

  describe "#get_history" do
    it "gets all history for a particular iteration" do
      VCR.use_cassette('get daily history container', record: :new_episodes) do
        daily_history_container = iteration.get_history

        daily_history_container.must_be_instance_of TrackerApi::Resources::DailyHistoryContainer
      end
    end
  end
end
