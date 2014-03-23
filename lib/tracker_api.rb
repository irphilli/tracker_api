require 'tracker_api/version'

# dependencies
require 'virtus'
require 'faraday'
require 'faraday_middleware'

# stdlib
require 'forwardable'
require 'logger'

module TrackerApi
  autoload :Error, 'tracker_api/error'
  autoload :Client, 'tracker_api/client'
  autoload :Logger, 'tracker_api/logger'

  module Errors
    class UnexpectedData < StandardError; end
  end

  module Endpoints
    autoload :Epic, 'tracker_api/endpoints/epic'
    autoload :Epics, 'tracker_api/endpoints/epics'
    autoload :Iterations, 'tracker_api/endpoints/iterations'
    autoload :Project, 'tracker_api/endpoints/project'
    autoload :Projects, 'tracker_api/endpoints/projects'
    autoload :Stories, 'tracker_api/endpoints/stories'
  end

  module Resources
    autoload :Account, 'tracker_api/resources/account'
    autoload :Epic, 'tracker_api/resources/epic'
    autoload :Iteration, 'tracker_api/resources/iteration'
    autoload :Label, 'tracker_api/resources/label'
    autoload :Project, 'tracker_api/resources/project'
    autoload :Story, 'tracker_api/resources/story'
    autoload :TimeZone, 'tracker_api/resources/time_zone'
  end
end
