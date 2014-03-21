require 'tracker_api/version'

# dependencies
# require 'addressable/uri'
require 'virtus'
require 'faraday'
require 'faraday_middleware'

# stdlib
# require 'forwardable'
require 'logger'
# require 'time'
# require 'yaml'

module TrackerApi
  autoload :Error, 'tracker_api/error'
  autoload :Client, 'tracker_api/client'
  autoload :Logger, 'tracker_api/logger'

  module Errors
    class UnexpectedData < StandardError; end
  end

  module Endpoints
    autoload :Epic, 'tracker_api/endpoints/epic'
    autoload :Project, 'tracker_api/endpoints/project'
    autoload :Projects, 'tracker_api/endpoints/projects'
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

  # def self.stringify_keys(hash)
  #   hash.inject({}) { |r, (k, v)| r.merge(k.to_s => v) }
  # end

  # def self.symbolize_keys(hash)
  #   hash.inject({}) { |r, (k, v)| r.merge(k.to_sym => v) }
  # end

  #def self.blank?(string)
  #  string.nil? || string == ''
  #end
end
