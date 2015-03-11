require_relative 'minitest_helper'

describe TrackerApi::Resources::Project do
  let(:pt_user) { PT_USER_1 }
  let(:client) { TrackerApi::Client.new token: pt_user[:token] }
  let(:project_id) { pt_user[:project_id] }
  let(:project) { VCR.use_cassette('get project') { client.project(project_id) } }

  describe '.epics' do
    it 'gets all epics for this project' do
      VCR.use_cassette('get epics', record: :new_episodes) do
        epics = project.epics

        epics.wont_be_empty
        epic = epics.first
        epic.must_be_instance_of TrackerApi::Resources::Epic
      end
    end

    describe 'with eager loading of epics' do
      let(:project_with_epics) do
        VCR.use_cassette('get project with epics') do
          client.project(project_id, fields: ':default,epics(:default,label(name))')
        end
      end

      # does not raise VCR::Errors::UnhandledHTTPRequestError
      it 'does not make an extra request' do
        epics = project_with_epics.epics

        epics.wont_be_empty
        epic = epics.first
        epic.must_be_instance_of TrackerApi::Resources::Epic
      end
    end
  end

  describe '.iterations' do
    it 'can get only done iterations' do
      VCR.use_cassette('get done iterations', record: :new_episodes) do
        offset          = -project.number_of_done_iterations_to_show.to_i
        done_iterations = project.iterations(scope: :done, offset: offset)

        done_iterations.wont_be_empty
        done_iterations.length.must_be :<=, project.number_of_done_iterations_to_show

        iteration = done_iterations.first
        iteration.must_be_instance_of TrackerApi::Resources::Iteration
      end
    end

    it 'can get current iteration' do
      VCR.use_cassette('get current iteration', record: :new_episodes) do
        iterations = project.iterations(scope: :current)

        iterations.wont_be_empty

        current = iterations.first
        current.must_be_instance_of TrackerApi::Resources::Iteration
        current.stories.wont_be_empty

        story = current.stories.first
        story.must_be_instance_of TrackerApi::Resources::Story
      end
    end

    it 'can get an iteration by number' do
      VCR.use_cassette('get iteration by number', record: :new_episodes) do
        iterations = project.iterations(number: 2)

        iterations.size.must_equal 1
        iterations.first.must_be_instance_of TrackerApi::Resources::Iteration
        iterations.first.number.must_equal 2

        iterations = project.iterations(number: 1)

        iterations.size.must_equal 1
        iterations.first.must_be_instance_of TrackerApi::Resources::Iteration
        iterations.first.number.must_equal 1

        iterations = project.iterations(number: 10_000)

        iterations.must_be_empty
      end
    end

    it 'requires an iteration number > 0' do
      VCR.use_cassette('get iteration by number', record: :new_episodes) do
        -> { project.iterations(number: 0)  }.must_raise(ArgumentError, /> 0/)
        -> { project.iterations(number: -1) }.must_raise(ArgumentError, /> 0/)
      end
    end
  end

  describe '.stories' do
    it 'can get unscheduled stories' do
      VCR.use_cassette('get unscheduled stories', record: :new_episodes) do
        stories = project.stories(with_state: :unscheduled)

        stories.wont_be_empty

        story = stories.first
        story.must_be_instance_of TrackerApi::Resources::Story
        story.current_state.must_equal 'unscheduled'
      end
    end

    it 'can create story' do
      VCR.use_cassette('create story') do
        story = project.create_story(name: 'Test story')

        story.must_be_instance_of TrackerApi::Resources::Story
        story.id.wont_be_nil
        story.id.must_be :>, 0
        story.name.must_equal 'Test story'
      end
    end

    it 'can create story with lengthy params' do
      VCR.use_cassette('create story with lengthy params') do
        story = project.create_story(name: 'Test story', description: ('Test description ' * 500))

        story.must_be_instance_of TrackerApi::Resources::Story
        story.id.wont_be_nil
        story.id.must_be :>, 0
        story.description.must_equal ('Test description ' * 500)
      end
    end
  end

  describe '.activity' do
    let(:story) { VCR.use_cassette('get unscheduled story') { project.stories(with_state: :unscheduled).first } }

    before do
      # create some activity
      story.name = "#{story.name}+"

      VCR.use_cassette('update story to create activity', record: :new_episodes) do
        story.save
      end
    end

    it 'gets all the activity for this project' do
      VCR.use_cassette('get project activity', record: :new_episodes) do
        activity = project.activity

        activity.wont_be_empty
        event = activity.first
        event.must_be_instance_of TrackerApi::Resources::Activity
      end
    end
  end
end
