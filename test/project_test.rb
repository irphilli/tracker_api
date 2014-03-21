require_relative 'minitest_helper'

describe TrackerApi::Client do
  let(:client) { TrackerApi::Client.new token: API_TOKEN_1  }
  #let(:projects) { VCR.use_cassette('all projects') { client.projects.all } }
  let(:project_id) { '123456' } #{ projects.first.id }

  describe 'Projects' do
    it 'can get project by id' do
      VCR.use_cassette('get project') do
        project = client.project(project_id)

        project.must_be_instance_of TrackerApi::Resources::Project
        project.id.must_equal project_id
      end
    end
  end
end
