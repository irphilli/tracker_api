require_relative 'minitest_helper'

describe TrackerApi::Resources::Task do
  let(:pt_user) { PT_USER_1 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }
  let(:project_id) { pt_user[:project_id] }
  let(:project) { VCR.use_cassette('get project') { client.project(project_id) } }
  let(:story_id) { '66728004' }
  let(:story) { VCR.use_cassette('get story') { project.story(story_id) } }
  let(:tasks) { VCR.use_cassette('get tasks', record: :new_episodes) {
                  VCR.use_cassette('get tasks for story') { story.tasks } } }
  let(:task) { tasks.first }

  it 'can update an existing task' do
    new_description = "#{task.description}+"
    task.description = new_description
    task.complete = true

    VCR.use_cassette('save task', record: :new_episodes) do
      task.save
    end

    _(task.description).must_equal new_description
    _(task.complete).must_equal true
    _(task.clean?).must_equal true
  end
end
