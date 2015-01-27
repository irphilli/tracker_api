require_relative 'minitest_helper'

describe TrackerApi do
  it 'has a version' do
    ::TrackerApi::VERSION.wont_be_nil
  end
end

describe TrackerApi::Client do
  it 'can be configured' do
    client = TrackerApi::Client.new(url:         'http://test.com',
                                    api_version: '/foo-bar/1',
                                    token:       '12345',
                                    logger:      LOGGER)

    client.url.must_equal 'http://test.com'
    client.api_version.must_equal '/foo-bar/1'
    client.token.must_equal '12345'
    client.logger.must_equal LOGGER
  end

  describe '.projects' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }

    it 'gets all projects' do
      VCR.use_cassette('get all projects', record: :new_episodes) do
        projects = client.projects(fields: ':default,account,current_velocity,labels(name),epics(:default,label(name))')

        projects.wont_be_empty
        project = projects.first
        project.must_be_instance_of TrackerApi::Resources::Project
        project.id.must_equal pt_user[:project_id]

        project.account.must_be_instance_of TrackerApi::Resources::Account

        project.labels.wont_be_empty
        project.labels.first.must_be_instance_of TrackerApi::Resources::Label

        project.epics.wont_be_empty
        project.epics.first.must_be_instance_of TrackerApi::Resources::Epic
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

        project.must_be_instance_of TrackerApi::Resources::Project
        project.id.must_equal project_id

        project.account.must_be_nil
        project.account_id.wont_be_nil
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

        me.must_be_instance_of TrackerApi::Resources::Me
        me.username.must_equal username

        me.projects.map(&:project_id).must_include project_id
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
        unpaged_stories.wont_be_empty
        unpaged_stories.length.must_be :>, 7

        # force pagination with a small limit
        paged_stories = project.stories(limit: 7)
        paged_stories.wont_be_empty
        paged_stories.length.must_equal unpaged_stories.length
        paged_stories.map(&:id).sort.uniq.must_equal unpaged_stories.map(&:id).sort.uniq
      end
    end

    it 'allows auto pagination to be turned off when just a subset of a list is desired' do
      VCR.use_cassette('client: get limited stories with no pagination', record: :new_episodes) do
        project = client.project(project_id)

        # force no pagination
        stories = project.stories(limit: 7, auto_paginate: false)
        stories.wont_be_empty
        stories.length.must_equal 7
      end
    end

    it 'can handle negative offsets' do
      VCR.use_cassette('client: done iterations with pagination', record: :new_episodes) do
        project = client.project(project_id)

        done_iterations = project.iterations(scope: :done, offset: -12, limit: 5)

        done_iterations.wont_be_empty
        done_iterations.length.must_be :<=, 12
      end
    end
  end

  describe '.story' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }

    it 'retrieves a story solely by story id' do
      VCR.use_cassette('client: get single story by story id', record: :new_episodes) do
        story = client.story('66728004')

        story.must_be_instance_of TrackerApi::Resources::Story
      end
    end
  end

  describe '.notifictions' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }

    it 'gets authenticated persons notifications' do
      VCR.use_cassette('get all notifications', record: :new_episodes) do
        notifications = client.notifications

        notifications.wont_be_empty
        notification = notifications.first
        notification.must_be_instance_of TrackerApi::Resources::Notification

        notification.project.id.must_equal pt_user[:project_id]
        notification.story.must_be_instance_of TrackerApi::Resources::Story
        notification.performer.must_be_instance_of TrackerApi::Resources::Person
      end
    end
  end

  describe '.activity' do
    let(:pt_user) { PT_USER_1 }
    let(:client) { TrackerApi::Client.new token: pt_user[:token] }

    it 'gets all my activities' do
      VCR.use_cassette('get my activities', record: :new_episodes) do
        activities = client.activity(fields: ':default')

        activities.wont_be_empty
        activity = activities.first
        activity.must_be_instance_of TrackerApi::Resources::Activity

        activity.changes.wont_be_empty
        activity.changes.first.must_be_instance_of TrackerApi::Resources::Change

        activity.primary_resources.wont_be_empty
        activity.primary_resources.first.must_be_instance_of TrackerApi::Resources::PrimaryResource

        activity.project.must_be_instance_of TrackerApi::Resources::Project

        activity.performed_by.must_be_instance_of TrackerApi::Resources::Person
      end
    end
  end
end
