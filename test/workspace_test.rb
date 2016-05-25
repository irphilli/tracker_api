require_relative 'minitest_helper'

describe TrackerApi::Resources::Workspace do
  let(:pt_user) { PT_USER_2 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }
  let(:workspace_id) { pt_user[:workspace_id] }
  let(:workspace) { VCR.use_cassette('get workspace') { client.workspace(workspace_id) } }

  describe '.projects' do
    it 'gets all projects for this workspace' do
      VCR.use_cassette('get workspace projects', record: :new_episodes) do
        workspace = client.workspace(pt_user[:workspace_id], fields: ':default,projects(id,name)')
        projects = workspace.projects

        projects.wont_be_empty

        projects.size.must_equal 2
        projects.first.must_be_instance_of TrackerApi::Resources::Project

        pt_user[:project_ids].must_include projects.first.id
        pt_user[:project_ids].must_include projects.last.id
      end
    end

  end
end
