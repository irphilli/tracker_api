#require_relative '../minitest_helper'
#
#describe TrackerApi::Client do
#  let(:client) { TrackerApi::Client.new }
#  let(:projects) { VCR.use_cassette('all projects') { client.projects.all } }
#  let(:project) { projects.first }
#
#  describe 'Project' do
#    it 'can get epics for a project' do
#      VCR.use_cassette('project epics') do
#        epics = project.epics
#
#        epics.must_be_instance_of TrackerApi::Client::Epics
#        epics.wont_be_empty
#        epics.size.must_equal 2
#      end
#    end
#  end
#end
