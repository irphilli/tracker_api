require_relative '../minitest_helper'

describe PivotalTracker::Client do
  let(:client) { PivotalTracker::Client.new }
  let(:projects) { VCR.use_cassette('all projects') { client.projects.all } }
  let(:project_id) { projects.first.id }

  describe 'Projects' do
    it 'can get project by id' do
      VCR.use_cassette('get project') do
        project = client.projects.get!(project_id)

        project.must_be_instance_of PivotalTracker::Client::Project
        project.id.must_equal project_id
      end
    end
  end
end
