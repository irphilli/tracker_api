require_relative 'minitest_helper'

describe TrackerApi do
  it 'has a version' do
    _(::TrackerApi::VERSION).wont_be_nil
  end
end

describe TrackerApi::Client do
  it 'can be configured' do
    client = TrackerApi::Client.new(url:         'http://test.com',
                                    api_version: '/foo-bar/1',
                                    token:       '12345',
                                    logger:      LOGGER)

    _(client.url).must_equal 'http://test.com'
    _(client.api_version).must_equal '/foo-bar/1'
    _(client.token).must_equal '12345'
    _(client.logger).must_equal LOGGER
  end

  describe '.projects' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }

    it 'gets all projects' do
      VCR.use_cassette('get all projects', record: :new_episodes) do
        projects = client.projects(fields: ':default,account,current_velocity,labels(name),epics(:default,label(name))')

        _(projects).wont_be_empty
        project = projects.first
        _(project).must_be_instance_of TrackerApi::Resources::Project
        _(project.id).must_equal pt_user[:project_id]

        _(project.account).must_be_instance_of TrackerApi::Resources::Account

        _(project.labels).wont_be_empty
        _(project.labels.first).must_be_instance_of TrackerApi::Resources::Label

        _(project.epics).wont_be_empty
        _(project.epics.first).must_be_instance_of TrackerApi::Resources::Epic
      end
    end
  end

  describe '.project' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }
    let(:project_id) { pt_user[:project_id] }

    it 'gets a project by id' do
      VCR.use_cassette('get project', record: :new_episodes) do
        project = client.project(project_id)

        _(project).must_be_instance_of TrackerApi::Resources::Project
        _(project.id).must_equal project_id

        _(project.account).must_be_nil
        _(project.account_id).wont_be_nil
      end
    end
  end

  describe '.workspace' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }

    it 'gets a workspace by id' do
      VCR.use_cassette('get workspace', record: :new_episodes) do
        workspace = client.workspace(pt_user[:workspace_id])

        _(workspace).must_be_instance_of TrackerApi::Resources::Workspace
        _(workspace.id).must_equal pt_user[:workspace_id]
        _(workspace.name).wont_be_empty
      end
    end
  end


  describe '.workspaces' do
    let(:pt_user) { PT_USER_2 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }

    it 'gets all workspaces' do
      VCR.use_cassette('get all workspaces', record: :new_episodes) do
        workspaces = client.workspaces(fields: ':default,projects(id,name)')

        _(workspaces).wont_be_empty
        workspace = workspaces.first
        _(workspace).must_be_instance_of TrackerApi::Resources::Workspace
        _(workspace.id).must_equal pt_user[:workspace_id]
      end
    end
  end



  describe '.me' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }
    let(:username) { pt_user[:username] }
    let(:project_id) { pt_user[:project_id] }

    it 'gets info about the authenticated user' do
      VCR.use_cassette('get me', record: :new_episodes) do
        me = client.me

        _(me).must_be_instance_of TrackerApi::Resources::Me
        _(me.username).must_equal username

        _(me.projects.map(&:project_id)).must_include project_id
      end
    end
  end

  describe '.paginate' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }
    let(:project_id) { pt_user[:project_id] }

    it 'auto paginates when needed' do
      VCR.use_cassette('client: get all stories with pagination', record: :new_episodes) do
        project         = client.project(project_id)

        # skip pagination with a hugh limit
        unpaged_stories = project.stories(limit: 300)
        _(unpaged_stories).wont_be_empty
        _(unpaged_stories.length).must_be :>, 7

        # force pagination with a small limit
        paged_stories = project.stories(limit: 7)
        _(paged_stories).wont_be_empty
        _(paged_stories.length).must_equal unpaged_stories.length
        _(paged_stories.map(&:id).sort.uniq).must_equal unpaged_stories.map(&:id).sort.uniq
      end
    end

    it 'allows auto pagination to be turned off when just a subset of a list is desired' do
      VCR.use_cassette('client: get limited stories with no pagination', record: :new_episodes) do
        project = client.project(project_id)

        # force no pagination
        stories = project.stories(limit: 7, auto_paginate: false)
        _(stories).wont_be_empty
        _(stories.length).must_equal 7
      end
    end

    it 'can handle negative offsets' do
      VCR.use_cassette('client: done iterations with pagination', record: :new_episodes) do
        project = client.project(project_id)

        done_iterations = project.iterations(scope: :done, offset: -12, limit: 5)

        _(done_iterations).wont_be_empty
        _(done_iterations.length).must_be :<=, 12
      end
    end
  end

  describe '.story' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }

    it 'retrieves a story solely by story id' do
      VCR.use_cassette('client: get single story by story id', record: :new_episodes) do
        story = client.story('66728004', fields: ':default,owned_by')

        _(story).must_be_instance_of TrackerApi::Resources::Story
        _(story.owned_by).wont_be_nil
      end
    end
  end

  describe '.epic' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }

    it 'retrieves an epic solely by epic id' do
      VCR.use_cassette('client: get single epic by epic id', record: :new_episodes) do
        epic = client.epic('1087314', fields: ':default,label_id')

        _(epic).must_be_instance_of TrackerApi::Resources::Epic
        _(epic.label_id).wont_be_nil
      end
    end
  end

  describe '.notifictions' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }

    it 'gets authenticated persons notifications' do
      VCR.use_cassette('get all notifications', record: :new_episodes) do
        notifications = client.notifications

        _(notifications).wont_be_empty
        notification = notifications.first
        _(notification).must_be_instance_of TrackerApi::Resources::Notification

        _(notification.project.id).must_equal pt_user[:project_id]
        _(notification.story).must_be_instance_of TrackerApi::Resources::Story
        _(notification.performer).must_be_instance_of TrackerApi::Resources::Person
      end
    end
  end

  describe '.activity' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }

    it 'gets all my activities' do
      VCR.use_cassette('get my activities', record: :new_episodes) do
        activities = client.activity(fields: ':default')

        _(activities).wont_be_empty
        activity = activities.first
        _(activity).must_be_instance_of TrackerApi::Resources::Activity

        _(activity.changes).wont_be_empty
        _(activity.changes.first).must_be_instance_of TrackerApi::Resources::Change

        _(activity.primary_resources).wont_be_empty
        _(activity.primary_resources.first).must_be_instance_of TrackerApi::Resources::PrimaryResource

        _(activity.project).must_be_instance_of TrackerApi::Resources::Project

        _(activity.performed_by).must_be_instance_of TrackerApi::Resources::Person
      end
    end
  end
end
