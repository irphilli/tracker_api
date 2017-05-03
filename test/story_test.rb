require_relative 'minitest_helper'

describe TrackerApi::Resources::Story do
  let(:pt_user_1) { PT_USER_1 }
  let(:pt_user_1_id) { pt_user_1[:id] }
  let(:pt_user_2) { PT_USER_2 }
  let(:pt_user_2_id) { pt_user_2[:id] }
  let(:client) { TrackerApi::Client.new token: pt_user_1[:token] }
  let(:project_id) { pt_user_1[:project_id] }
  let(:project) { VCR.use_cassette('get project') { client.project(project_id) } }
  let(:story_id) { '66728004' }
  let(:story_in_epic_id) { '66728030' }
  let(:another_story_id) { '66728000' }
  let(:story_id_no_existing_labels) { '82330712' }
  let(:story) { VCR.use_cassette('get story') { project.story(story_id) } }

  it 'can update an existing story' do
    new_name   = "#{story.name}+"
    story.name = new_name

    VCR.use_cassette('save story', record: :new_episodes) do
      story.save
    end

    story.name.must_equal new_name
    story.clean?.must_equal true
  end

  it 'can update multiple attributes of an existing story at once' do
    new_name = "#{story.name}+"
    new_desc = "#{story.description}+"

    story.attributes = { name: new_name, description: new_desc }

    VCR.use_cassette('save story with multiple changes', record: :new_episodes) do
      story.save
    end

    story.name.must_equal new_name
    story.description.must_equal new_desc
  end

  it 'can add new labels to an existing story' do
    new_label_name = "super-special-label"

    story.labels.map(&:name).wont_include new_label_name

    story.add_label(new_label_name)

    VCR.use_cassette('save story with new label', record: :new_episodes) do
      story.save
    end

    story.labels.wont_be_empty
    story.labels.map(&:name).must_include new_label_name
  end

  it 'can add new labels to an existing story without existing labels' do
    story = VCR.use_cassette('get story no existing labels') { project.story(story_id_no_existing_labels) }
    story.labels.must_be_nil

    new_label_name = "super-special-label"
    story.add_label(new_label_name)

    VCR.use_cassette('save previously no label story with new label', record: :new_episodes) do
      story.save
    end

    story.labels.wont_be_empty
    story.labels.map(&:name).must_include new_label_name
  end

  it 'does not remove existing labels when updating story fields' do
    story_in_epic = nil
    VCR.use_cassette('get story in epic') do
      story_in_epic = project.story(story_in_epic_id)
    end

    original_labels = story_in_epic.labels
    original_label_list = story_in_epic.label_list

    VCR.use_cassette('create story comment', record: :new_episodes) do
      story_in_epic.create_comment text: "This is a test comment."
    end

    story_in_epic.estimate = 2
    story_in_epic.current_state = 'started'

    VCR.use_cassette('save story in epic', record: :new_episodes) do
      story_in_epic.save
    end

    story_in_epic.labels.must_equal original_labels
    story_in_epic.label_list.must_equal original_label_list
  end

  it 'does not send unmodified fields when saving' do
    story_with_one_change = TrackerApi::Resources::Story::UpdateRepresenter.new(TrackerApi::Resources::Story.new(name: "new_name"))
    expected_json = MultiJson.dump({name: "new_name"})

    expected_json.must_equal story_with_one_change.to_json
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

  describe '.owner_ids' do
    it 'gets owner_ids for this story' do
      VCR.use_cassette('get story', record: :new_episodes) do
        story = project.story(story_id)
        owner_ids = story.owner_ids

        owner_ids.wont_be_empty
        owner_ids.first.must_be_instance_of Fixnum
      end
    end

    it 'update owners for a story' do
      VCR.use_cassette('get story', record: :new_episodes) do
        story = project.story(story_id)

        # save with one owner
        one_owner = [pt_user_1_id]
        story.owner_ids = one_owner
        VCR.use_cassette('save story with one owner') { story.save }

        story.owner_ids.wont_be_empty
        story.owner_ids.must_equal one_owner

        # save with two owners
        two_owners = [pt_user_1_id, pt_user_2_id]
        story.owner_ids = two_owners
        VCR.use_cassette('save story with two owners') { story.save }

        story.owner_ids.wont_be_empty
        story.owner_ids.must_equal two_owners
      end
    end
  end

  describe '.add_owner' do
    it 'add owner to a story' do
      VCR.use_cassette('get story', record: :new_episodes) do
        story = project.story(story_id)

        # clear current owners
        story.owner_ids = []

        story.add_owner(TrackerApi::Resources::Person.new(id: 123))

        story.owner_ids.wont_be_empty
        story.owner_ids.must_equal [123]
      end
    end

    it 'add owners by id to a story' do
      VCR.use_cassette('get story', record: :new_episodes) do
        story = project.story(story_id)

        # clear current owners
        story.owner_ids = []

        story.add_owner(123)
        story.add_owner(456)
        # test dups are not added
        story.add_owner(123)

        story.owner_ids.wont_be_empty
        story.owner_ids.must_equal [123, 456]
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

  describe '.transitions' do
    it 'gets all story transitions with just project_id and story_id' do
      VCR.use_cassette('get story transitions', record: :new_episodes) do
        story = TrackerApi::Resources::Story.new( client:     client,
                                                  project_id: project_id,
                                                  id:         another_story_id)

        transitions = story.transitions
        transition = transitions.first
        transition.must_be_instance_of TrackerApi::Resources::StoryTransition
      end
    end
  end
end
