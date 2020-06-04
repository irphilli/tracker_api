require_relative 'minitest_helper'

describe TrackerApi::Resources::Release do
  let(:pt_user) { PT_USER_1 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }
  let(:project_id) { pt_user[:project_id] }
  let(:project) { VCR.use_cassette('get project') { client.project(project_id) } }

  describe '.stories' do
    it 'returns all the stories related to a release' do
      releases = VCR.use_cassette('get releases') { project.releases }
      release = releases.find { |release| release.name == 'Beta launch' }

      VCR.use_cassette('release stories', record: :new_episodes) do
        stories = release.stories

        _(stories.size).must_equal 9
        _(stories.first).must_be_instance_of TrackerApi::Resources::Story
      end
    end
  end
end
