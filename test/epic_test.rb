#require_relative '../minitest_helper'
#
#describe TrackerApi::Client do
#  let(:client) { TrackerApi::Client.new }
#  let(:projects) { VCR.use_cassette('all projects') { client.projects.all } }
#  let(:project) { projects.first }
#  let(:epics) { VCR.use_cassette('project epics') { project.epics } }
#  let(:epic) { epics.first }
#
#  describe 'Epic' do
#    it 'can get an epics label' do
#      epic.must_be_instance_of TrackerApi::Client::Epic
#      epic.label.wont_be_empty
#    end
#  end
#end
