require_relative '../minitest_helper'

describe PivotalTracker::Client do
  let(:client) { PivotalTracker::Client.new }

  describe 'Projects' do
    it 'can get all projects' do
      VCR.use_cassette('all projects') do
        projects = client.projects.all

        projects.must_be_instance_of PivotalTracker::Client::Projects
        projects.wont_be_empty
      end
    end
  end
end
