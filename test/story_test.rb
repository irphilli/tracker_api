require_relative 'minitest_helper'

describe TrackerApi::Resources::Story do
  let(:pt_user) { PT_USER_1 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }
  let(:project_id) { pt_user[:project_id] }
  let(:project) { VCR.use_cassette('get project') { client.project(project_id) } }
  let(:story_id) { '66728004' }
  let(:another_story_id) { '66728000' }
  let(:story) { VCR.use_cassette('get story') { project.story(story_id) } }


  it '.save is deprecated' do
    VCR.use_cassette('save story', record: :new_episodes) do
      assert_output(nil, /\[DEPRECATION\]/) { story.save }
    end
  end

  it 'can update an existing story' do
    new_name = "#{story.name}+"

    VCR.use_cassette('save story', record: :new_episodes) do
      updated_story = TrackerApi::Endpoints::Story.new(client).update(project_id,
                                                                      story_id,
                                                                      {name: new_name})

      updated_story.name.must_equal new_name
    end
  end

  it 'can update multiple attributes of an existing story at once' do
    new_name = "#{story.name}+"
    new_desc = "#{story.description}+"

    VCR.use_cassette('save story with multiple changes', record: :new_episodes) do
      updated_story = TrackerApi::Endpoints::Story.new(client).update(project_id,
                                                                      story_id,
                                                                      { name:         new_name,
                                                                        description:  new_desc })

      updated_story.name.must_equal new_name
      updated_story.description.must_equal new_desc
    end
  end

  it 'can add new labels to an existing story' do
    new_label_name = 'super-special-label'

    story.labels.map(&:name).wont_include new_label_name

    new_label = TrackerApi::Resources::Label.new(name: new_label_name)
    story.labels << new_label

    VCR.use_cassette('save story with new label', record: :new_episodes) do
      story.save
    end

    story.labels.wont_be_empty
    story.labels.map(&:name).must_include new_label_name
  end

  it 'objects are equal based on id' do
    story_a = story
    story_b = VCR.use_cassette('get story') { project.story(story_id) }
    story_c = VCR.use_cassette('get another story') { project.story(another_story_id) }

    story_a.must_equal story_b
    story_a.hash.must_equal story_b.hash
    story_a.eql?(story_b).must_equal true
    story_a.equal?(story_b).must_equal false

    story_a.wont_equal story_c
    story_a.hash.wont_equal story_c.hash
    story_a.eql?(story_c).must_equal false
    story_a.equal?(story_c).must_equal false
  end

  describe '.owners' do
    it 'gets all owners for this story with eager loading' do
      skip('Until this is resolved: https://pivotaltracker.zendesk.com/requests/35823')

      story = VCR.use_cassette('get story with owners', record: :new_episodes) do
        project.story(story_id, fields: ':default,owners')
      end

      # this should not raise VCR::Errors::UnhandledHTTPRequestError since
      # it should not be making another HTTP request.
      owners = story.owners

      owners.wont_be_empty
      owner = owners.first
      owner.must_be_instance_of TrackerApi::Resources::Person
    end

    it 'gets all owners for this story' do
      VCR.use_cassette('get story', record: :new_episodes) do
        story = project.story(story_id)
        owners = VCR.use_cassette('get owners for story') { story.owners }

        owners.wont_be_empty
        owner = owners.first
        owner.must_be_instance_of TrackerApi::Resources::Person
      end
    end
  end

  describe '.tasks' do
    it 'gets all tasks for this story with eager loading' do
      VCR.use_cassette('get story with tasks', record: :new_episodes) do
        tasks = project.story(story_id, fields: ':default,tasks').tasks

        tasks.wont_be_empty
        task = tasks.first
        task.must_be_instance_of TrackerApi::Resources::Task
      end
    end

    it 'gets all tasks for this story' do
      VCR.use_cassette('get tasks', record: :new_episodes) do
        story = project.story(story_id)
        tasks = VCR.use_cassette('get tasks for story') { story.tasks }

        tasks.wont_be_empty
        task = tasks.first
        task.must_be_instance_of TrackerApi::Resources::Task
      end
    end

    it 'gets all tasks even when the project_id is excluded from the story fields' do
      VCR.use_cassette('get tasks when stories filtered', record: :new_episodes) do
        stories = project.stories(with_state: 'unstarted', fields: 'name,story_type')
        stories.each do |story|
          tasks = story.tasks
          unless tasks.empty?
            task = tasks.first
            task.must_be_instance_of TrackerApi::Resources::Task
          end
        end
      end
    end

    it 'can create task' do
      VCR.use_cassette('create task') do
        task = project.story(story_id).create_task(description: 'Test task')

        task.must_be_instance_of TrackerApi::Resources::Task
        task.id.wont_be_nil
        task.id.must_be :>, 0
        task.description.must_equal 'Test task'
      end
    end
  end

  describe '.activity' do
    before do
      # create some activity
      story.name = "#{story.name}+"

      VCR.use_cassette('update story to create activity', record: :new_episodes) do
        story.save
      end
    end

    it 'gets all the activity for this story' do
      VCR.use_cassette('get story activity', record: :new_episodes) do
        activity = story.activity

        activity.wont_be_empty
        event = activity.first
        event.must_be_instance_of TrackerApi::Resources::Activity
      end
    end
  end

  describe '.owners' do
    it 'gets all owners of this story' do
      VCR.use_cassette('get story owners', record: :new_episodes) do
        owners = story.owners

        owners.wont_be_empty
        owner = owners.first
        owner.must_be_instance_of TrackerApi::Resources::Person
      end
    end
  end

  describe '.comments' do
    it 'gets all comments of story with just project_id and story_id' do
      VCR.use_cassette('get story comments', record: :new_episodes) do
        story = TrackerApi::Resources::Story.new( client:     client,
                                                  project_id: project_id,
                                                  id:         story_id)

        comments = story.comments
        comment = comments.first
        comment.must_be_instance_of TrackerApi::Resources::Comment
      end
    end
  end

end
