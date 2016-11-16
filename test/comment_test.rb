require_relative 'minitest_helper'

describe TrackerApi::Resources::Comment do
  let(:pt_user) { PT_USER_1 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }
  let(:project_id) { pt_user[:project_id] }
  let(:project) { VCR.use_cassette('get project') { client.project(project_id) } }
  let(:story_id) { '66728004' }
  let(:story) { VCR.use_cassette('get story') { project.story(story_id) } }
  let(:comments) { VCR.use_cassette('get comments') { story.comments } }
  let(:existing_comment) { comments.first }

  it 'can create a comment given a story' do
    text = "Test creating a comment"
    comment = nil
    VCR.use_cassette('create comment', record: :new_episodes) do
      comment = story.create_comment(text: text)
    end

    comment.text.must_equal text
    comment.clean?.must_equal true
  end

  it 'can update an existing comment' do
    new_text = "#{existing_comment.text}+"
    existing_comment.text = new_text

    VCR.use_cassette('save comment', record: :new_episodes) do
      existing_comment.save
    end

    existing_comment.text.must_equal new_text
    existing_comment.clean?.must_equal true
  end
end
