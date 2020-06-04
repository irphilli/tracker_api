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

        _(epics).wont_be_empty
        epic = epics.first
        _(epic).must_be_instance_of TrackerApi::Resources::Epic
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

        _(epics).wont_be_empty
        epic = epics.first
        _(epic).must_be_instance_of TrackerApi::Resources::Epic
      end
    end
  end

  describe '.labels' do
    describe 'with eager loading' do
      let(:project_with_labels) do
        VCR.use_cassette('get project with labels') do
          client.project(project_id, fields: ':default,labels')
        end
      end

      it 'gets all labels for this project' do
        labels = project_with_labels.labels

        _(labels).wont_be_empty
        label = labels.first
        _(label).must_be_instance_of TrackerApi::Resources::Label
      end
    end

    it 'gets all labels for this project' do
      VCR.use_cassette('get labels', record: :new_episodes) do
        labels = project.labels

        _(labels).wont_be_empty
        label = labels.first
        _(label).must_be_instance_of TrackerApi::Resources::Label
      end
    end
  end

  describe '.iterations' do
    it 'can get only done iterations' do
      VCR.use_cassette('get done iterations', record: :new_episodes) do
        offset          = -project.number_of_done_iterations_to_show.to_i
        done_iterations = project.iterations(scope: :done, offset: offset)

        _(done_iterations).wont_be_empty
        _(done_iterations.length).must_be :<=, project.number_of_done_iterations_to_show

        iteration = done_iterations.first
        _(iteration).must_be_instance_of TrackerApi::Resources::Iteration
      end
    end

    it 'can get current iteration' do
      VCR.use_cassette('get current iteration', record: :new_episodes) do
        iterations = project.iterations(scope: :current)

        _(iterations).wont_be_empty

        current = iterations.first
        _(current).must_be_instance_of TrackerApi::Resources::Iteration
        _(current.stories).wont_be_empty

        story = current.stories.first
        _(story).must_be_instance_of TrackerApi::Resources::Story
      end
    end

    it 'can get iteration with non-default fields' do
      VCR.use_cassette('get current iteration', record: :new_episodes) do
        iterations = project.iterations(scope: :current, fields: ":default,velocity,points,accepted_points,effective_points")

        _(iterations).wont_be_empty

        current = iterations.first
        _(current.velocity).must_equal 10.0
        _(current.points).must_equal 9.0
        _(current.accepted_points).must_equal 0
        _(current.effective_points).must_equal 9.0
      end
    end

    it 'can get an iteration by number' do
      VCR.use_cassette('get iteration by number', record: :new_episodes) do
        iterations = project.iterations(number: 2)

        _(iterations.size).must_equal 1
        _(iterations.first).must_be_instance_of TrackerApi::Resources::Iteration
        _(iterations.first.number).must_equal 2

        iterations = project.iterations(number: 1)

        _(iterations.size).must_equal 1
        _(iterations.first).must_be_instance_of TrackerApi::Resources::Iteration
        _(iterations.first.number).must_equal 1

        iterations = project.iterations(number: 10_000)

        _(iterations).must_be_empty
      end
    end

    it 'requires an iteration number > 0' do
      VCR.use_cassette('get iteration by number', record: :new_episodes) do
        _(-> { project.iterations(number: 0) }).must_raise(ArgumentError, /> 0/)
        _(-> { project.iterations(number: -1) }).must_raise(ArgumentError, /> 0/)
      end
    end
  end

  describe '.stories' do
    it 'can get unscheduled stories' do
      VCR.use_cassette('get unscheduled stories', record: :new_episodes) do
        stories = project.stories(with_state: :unscheduled)

        _(stories).wont_be_empty

        story = stories.first
        _(story).must_be_instance_of TrackerApi::Resources::Story
        _(story.current_state).must_equal 'unscheduled'
      end
    end

    it 'can create story' do
      VCR.use_cassette('create story') do
        story = project.create_story(name: 'Test story')

        _(story).must_be_instance_of TrackerApi::Resources::Story
        _(_(story.id)).wont_be_nil
        _(story.id).must_be :>, 0
        _(story.name).must_equal 'Test story'
      end
    end

    it 'can create story with lengthy params' do
      VCR.use_cassette('create story with lengthy params') do
        story = project.create_story(name: 'Test story', description: ('Test description ' * 500))

        _(story).must_be_instance_of TrackerApi::Resources::Story
        _(_(story.id)).wont_be_nil
        _(story.id).must_be :>, 0
        _(story.description).must_equal ('Test description ' * 500)
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

        _(activity).wont_be_empty
        event = activity.first
        _(event).must_be_instance_of TrackerApi::Resources::Activity
      end
    end
  end

  describe '.search' do
    let(:pt_user) { PT_USER_3 }

    it 'can search a project' do
      VCR.use_cassette('search project') do
        project = client.project(pt_user[:project_id])
        search_container = project.search('name:"story to test search"')

        _(search_container).wont_be_nil
        _(search_container).must_be_instance_of TrackerApi::Resources::SearchResultContainer
        _(search_container.epics).must_be_instance_of TrackerApi::Resources::EpicsSearchResult
        _(search_container.stories).must_be_instance_of TrackerApi::Resources::StoriesSearchResult
        _(search_container.stories.stories.first[:id]).must_equal 143444685
      end
    end
  end

  describe '.releases' do
    it 'gets all of the releases for the project' do
      VCR.use_cassette('get releases', record: :new_episodes) do
        releases = project.releases

        _(releases).wont_be_empty
        _(releases.size).must_equal 3
        _(releases.first).must_be_instance_of TrackerApi::Resources::Release
      end
    end
  end
end
