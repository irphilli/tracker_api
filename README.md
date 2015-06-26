# TrackerApi

[![Gem Version](https://badge.fury.io/rb/tracker_api.png)](http://badge.fury.io/rb/tracker_api)
[![Build Status](https://travis-ci.org/dashofcode/tracker_api.png?branch=master)](https://travis-ci.org/dashofcode/tracker_api)
[![Code Climate](https://codeclimate.com/github/dashofcode/tracker_api.png)](https://codeclimate.com/github/dashofcode/tracker_api)
[![Coverage Status](https://coveralls.io/repos/dashofcode/tracker_api/badge.png?branch=master)](https://coveralls.io/r/dashofcode/tracker_api?branch=master)
[![Dependency Status](https://gemnasium.com/dashofcode/tracker_api.png)](https://gemnasium.com/dashofcode/tracker_api)

This gem allows you to easily use the [Pivotal Tracker v5 API](https://www.pivotaltracker.com/help/api/rest/v5).

It’s powered by [Faraday](https://github.com/lostisland/faraday) and [Virtus](https://github.com/solnic/virtus).

##Demonstration
[Dash of Agile](https://www.dashofagile.com) uses `tracker_api` to create agile dashboards from Pivotal Tracker projects.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'tracker_api', '~> 0.2.0'
```

And then execute:
```bash
$ bundle install
```

Or install it yourself as:
```bash
$ gem install tracker_api
```

## Basic Usage

```ruby
client = TrackerApi::Client.new(token: 'my-api-token')                    # Create API client

client.me.email                                                           # Get email for the authenticated person
client.activity                                                           # Get a list of all the activity performed the authenticated person
client.notifications                                                      # Get notifications for the authenticated person

projects = client.projects                                                # Get all projects
project  = client.project(123456)                                         # Find project with given ID
project.activity                                                          # Get a list of all the activity performed on this project

project.stories                                                           # Get all stories for a project
project.stories(with_state: :unscheduled, limit: 10)                      # Get 10 unscheduled stories for a project
project.stories(filter: 'requester:OWK label:"jedi stuff"')               # Get all stories that match the given filters
project.create_story(name: 'Destroy death star')                          # Create a story with the name 'Destroy death star'

story = project.story(847762630)                                          # Find a story with the given ID
story.activity                                                            # Get a list of all the activity performed on this story

story.name = 'Save the Ewoks'                                             # Update a single story attribute
story.attributes = { name: 'Save the Ewoks', description: '...' }         # Update multiple story attributes
story.labels << TrackerApi::Resources::Label.new(name: 'Endor')           # Add a new label to an existing story
story.save                                                                # Save changes made to a story

epics = project.epics                                                     # Get all epics for a project
epic  = epics.first
label = epic.label                                                        # Get an epic's label
```

## Eager Loading

See Pivotal Tracker API [documentation](https://www.pivotaltracker.com/help/api#Response_Controlling_Parameters) for how to use the `fields` parameter.

```ruby
client = TrackerApi::Client.new(token: 'my-api-token')                    # Create API client

client.project(project_id, fields: ':default,labels(name)')               # Eagerly get labels with a project
client.project(project_id, fields: ':default,epics')                      # Eagerly get epics with a project
client.project(project_id).stories(fields: ':default,tasks')              # Eagerly get stories with tasks
client.project.stories(fields: ':default,comments(:default,person)')      # Eagerly get stories with comments and the person that made the comment
story.comments(fields: ':default,person')                                 # Eagerly get comments and the person that made the comment for a story
```

## TODO

- Add missing resources and endpoints
- Add create, update, delete for resources

## Contributing

Currently this client supports read-only access to Pivotal Tracker.
We will be extending it as our use cases require, but are always happy to accept contributions.

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
