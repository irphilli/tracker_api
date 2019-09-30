require_relative 'minitest_helper'

describe TrackerApi::Resources::FileAttachment do
  let(:pt_user) { PT_USER_1 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }
  let(:project_id) { pt_user[:project_id] }
  let(:project) { VCR.use_cassette('get project') { client.project(project_id) } }
  let(:story_id) { '66728004' }
  let(:story) { VCR.use_cassette('get story') { project.story(story_id) } }

  it 'can be deleted' do
    VCR.use_cassette('delete an attachment', record: :new_episodes) do
      comment_with_attachments = story.create_comment(text: "test comment", files: [File.expand_path('../Gemfile', File.dirname(__FILE__))])
      _(comment_with_attachments.attachments(reload: true).size).must_equal 1
      comment_with_attachments.attachments.first.delete
      _(comment_with_attachments.attachments(reload: true).size).must_equal 0
    end
  end
end
