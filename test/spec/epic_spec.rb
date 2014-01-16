require_relative '../minitest_helper'

describe PivotalTracker::Client do
  let(:client) { PivotalTracker::Client.new }
  let(:projects) { VCR.use_cassette('all projects') { client.projects.all } }
  let(:project) { projects.first }
  let(:epics) { VCR.use_cassette('project epics') { project.epics } }
  let(:epic) { epics.first }

  describe 'Epic' do
    it 'can get an epics label' do
      epic.must_be_instance_of PivotalTracker::Client::Epic
      epic.label.wont_be_empty
    end
  end
end
