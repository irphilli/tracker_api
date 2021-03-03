require_relative 'minitest_helper'

describe TrackerApi::Resources::Comment do
  let(:pt_user) { PT_USER_1 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }
  let(:project_id) { pt_user[:project_id] }
  let(:project) { VCR.use_cassette('get project') { client.project(project_id) } }
  let(:story_id) { '66728004' }
  let(:story) { VCR.use_cassette('get story') { project.story(story_id) } }
  let(:story_comments) { VCR.use_cassette('get story comments') { story.comments } }
  let(:epic_id) { '4737194' }
  let(:epic) { VCR.use_cassette('get epic') { project.epic(epic_id) } }
  let(:epic_comments) { VCR.use_cassette('get epic comments') { epic.comments } }
  let(:existing_story_comment) { story_comments.first }
  let(:existing_epic_comment) { epic_comments.first }

  it 'can create a comment given a story' do
    text = "Test creating a comment"
    comment = nil
    VCR.use_cassette('create story comment', record: :new_episodes) do
      comment = story.create_comment(text: text)
    end

    _(comment.text).must_equal text
    _(comment.clean?).must_equal true
  end

  it 'can create a comment given an epic' do
    text = "Test creating a comment"
    comment = nil
    VCR.use_cassette('create epic comment', record: :new_episodes) do
      comment = epic.create_comment(text: text)
    end

    _(comment.text).must_equal text
    _(comment.clean?).must_equal true
  end

  it 'can create a story comment with file attachment' do
    text = "Test creating a comment"
    comment = nil
    files = [File.expand_path('../Gemfile', File.dirname(__FILE__))]
    VCR.use_cassette('create story comment with attachment', record: :new_episodes) do
      comment = story.create_comment(text: text, files: files)
    end
    _(comment.text).must_equal text
    _(comment.attachments.size).must_equal 1
    _(comment.clean?).must_equal true
  end

  it 'can create an epic comment with file attachment' do
    text = "Test creating a comment"
    comment = nil
    files = [File.expand_path('../Gemfile', File.dirname(__FILE__))]
    VCR.use_cassette('create epic comment with attachment', record: :new_episodes) do
      comment = epic.create_comment(text: text, files: files)
    end
    _(comment.text).must_equal text
    _(comment.attachments.size).must_equal 1
    _(comment.clean?).must_equal true
  end

  it 'can update an existing story comment' do
    new_text = "#{existing_story_comment.text}+"
    existing_story_comment.text = new_text

    VCR.use_cassette('save story comment', record: :new_episodes) do
      existing_story_comment.save
    end

    _(existing_story_comment.text).must_equal new_text
    _(existing_story_comment.clean?).must_equal true
  end

  it 'can update an existing epic comment' do
    new_text = "#{existing_epic_comment.text}+"
    existing_epic_comment.text = new_text

    VCR.use_cassette('save epic comment', record: :new_episodes) do
      existing_epic_comment.save
    end

    _(existing_epic_comment.text).must_equal new_text
    _(existing_epic_comment.clean?).must_equal true
  end

  it 'can create attachments in a story comment' do
    files = [File.expand_path('../Gemfile', File.dirname(__FILE__))]
    VCR.use_cassette('create story attachments', record: :new_episodes) do
      existing_story_comment.create_attachments(files: files)
      assert existing_story_comment.attachments.size > 0
      _(existing_story_comment.clean?).must_equal true
    end
  end

  it 'can create attachments in an epic comment' do
    files = [File.expand_path('../Gemfile', File.dirname(__FILE__))]
    VCR.use_cassette('create epic attachments', record: :new_episodes) do
      existing_epic_comment.create_attachments(files: files)
      assert existing_epic_comment.attachments.size > 0
      _(existing_epic_comment.clean?).must_equal true
    end
  end

  it 'can delete attachments in a story comment' do
    files = [File.expand_path('../Gemfile', File.dirname(__FILE__))]
    VCR.use_cassette('delete story attachments', record: :new_episodes) do
      existing_story_comment.create_attachments(files: files)
      assert existing_story_comment.attachments.size > 0
      existing_story_comment.delete_attachments
      _(existing_story_comment.attachments.size).must_equal 0
    end
  end

  it 'can delete attachments in an epic comment' do
    files = [File.expand_path('../Gemfile', File.dirname(__FILE__))]
    VCR.use_cassette('delete epic attachments', record: :new_episodes) do
      existing_epic_comment.create_attachments(files: files)
      assert existing_epic_comment.attachments.size > 0
      existing_epic_comment.delete_attachments
      _(existing_epic_comment.attachments.size).must_equal 0
    end
  end

  it 'can delete a story comment' do
    VCR.use_cassette('delete story comment', record: :new_episodes) do
      current_story = project.story(story_id)
      new_comment_id = current_story.create_comment(text: "test comment").id
      _(current_story.comments.last.id).must_equal new_comment_id
      current_story.comments.last.delete
      current_story = project.story(story_id)
      _(current_story.comments.last.id).wont_equal new_comment_id
    end
  end

  it 'can delete an epic comment' do
    VCR.use_cassette('delete epic comment', record: :new_episodes) do
      current_epic = project.epic(epic_id)
      new_comment_id = current_epic.create_comment(text: "test comment").id
      _(current_epic.comments.last.id).must_equal new_comment_id
      current_epic.comments.last.delete
      current_epic = project.epic(epic_id)
      _(current_epic.comments.last.id).wont_equal new_comment_id
    end
  end
end
