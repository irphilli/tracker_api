require_relative 'minitest_helper'

describe TrackerApi::Client do
  let(:pt_user) { PT_USER_1 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }

  describe 'Projects' do
    it 'can get all projects' do
      VCR.use_cassette('all projects', record: :new_episodes) do
        projects = client.projects(fields: ':default,account,current_velocity,labels(name),epics(:default,label(name))')

        projects.wont_be_empty
        project = projects.first
        project.must_be_instance_of TrackerApi::Resources::Project
        project.id.must_equal pt_user[:project_id]
      end
    end
  end
end
