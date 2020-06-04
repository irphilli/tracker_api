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

    _(comment.text).must_equal text
    _(comment.clean?).must_equal true
  end

  it 'can create a comment with file attachment' do
    text = "Test creating a comment"
    comment = nil
    files = [File.expand_path('../Gemfile', File.dirname(__FILE__))]
    VCR.use_cassette('create comment with attachment', record: :new_episodes) do
      comment = story.create_comment(text: text, files: files)
    end
    _(comment.text).must_equal text
    _(comment.attachments.size).must_equal 1
    _(comment.clean?).must_equal true
  end

  it 'can update an existing comment' do
    new_text = "#{existing_comment.text}+"
    existing_comment.text = new_text

    VCR.use_cassette('save comment', record: :new_episodes) do
      existing_comment.save
    end

    _(existing_comment.text).must_equal new_text
    _(existing_comment.clean?).must_equal true
  end

  it 'can create attachments in a comment' do
    files = [File.expand_path('../Gemfile', File.dirname(__FILE__))]
    VCR.use_cassette('create attachments', record: :new_episodes) do
      existing_comment.create_attachments(files: files)
      _(existing_comment.attachments.size).must_equal 1
      _(existing_comment.clean?).must_equal true
    end
  end

  it 'can delete attachments in a comment' do
    files = [File.expand_path('../Gemfile', File.dirname(__FILE__))]
    VCR.use_cassette('delete attachments', record: :new_episodes) do
      existing_comment.create_attachments(files: files)
      _(existing_comment.attachments.size).must_equal 1
      existing_comment.delete_attachments
      _(existing_comment.attachments.size).must_equal 0
    end
  end

  it 'can delete a comment' do
    VCR.use_cassette('delete comment', record: :new_episodes) do
      current_story = project.story(story_id)
      new_comment_id = current_story.create_comment(text: "test comment").id
      _(current_story.comments.last.id).must_equal new_comment_id
      current_story.comments.last.delete
      current_story = project.story(story_id)
      _(current_story.comments.last.id).wont_equal new_comment_id
    end
  end
end
