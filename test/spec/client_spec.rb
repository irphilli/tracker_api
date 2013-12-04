require_relative '../minitest_helper'

describe PivotalTracker do
  it 'has a version' do
    ::PivotalTracker::VERSION.wont_be_nil
  end
end

describe PivotalTracker::Client do
  it 'can get projects' do
    client = PivotalTracker::Client.new(token: '12345')

    projects = client.projects.all
    projects.wont_be_empty
  end

  it 'can get epics for a project' do
    client = PivotalTracker::Client.new(token: '12345')

    projects = client.projects.all
    projects.wont_be_empty

    epics = projects.first.epics
    epics.wont_be_empty
  end


end
