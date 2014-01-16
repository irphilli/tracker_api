require_relative '../minitest_helper'

describe PivotalTracker::Client do
  let(:client) { PivotalTracker::Client.new }
  let(:projects) { VCR.use_cassette('all projects') { client.projects.all } }
  let(:project) { projects.first }

  describe 'Project' do
    it 'can get current iteration for a project' do
      VCR.use_cassette('current iteration') do
        iteration = project.current_iteration

        iteration.must_be_instance_of PivotalTracker::Client::Iteration
      end
    end
  end
end
