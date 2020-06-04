#Bundler.require(:test)
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'coveralls'
Coveralls.wear!

require 'minitest/byebug' if ENV['DEBUG']
require 'minitest/autorun'

require 'mocha'
require('mocha/minitest')

require 'awesome_print'
require 'multi_json'
require 'vcr'

require 'tracker_api'
# require File.expand_path('../../lib/tracker_api', __FILE__)

Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each { |f| require f }

VCR.configure do |c|
  c.ignore_localhost         = true
  c.cassette_library_dir     = File.expand_path('../vcr/cassettes', __FILE__).to_s
  c.default_cassette_options = { serialize_with: :json }
  c.hook_into :faraday
  c.allow_http_connections_when_no_cassette = false
end

# These API Tokens are for a user with just one Public Sample Project
PT_USER_1 = { username: 'trackerapi1', password: 'trackerapi1', token: 'd55c3bc1f74346b843ca84ba340b29bf', project_id: 1027488, workspace_id: 375106, id: 1266314 }
PT_USER_2 = { username: 'trackerapi2', password: 'trackerapi2', token: 'ab4c5895f57995bb7547986eacf91160', project_ids: [1027488, 1027492], workspace_id: 581707, id: 1266316 }
PT_USER_3 = { username: 'trackerapi3', password: 'trackerapi3', token: '77f9b9a466c436e6456939208c84c973', project_id: 1027494 }
PT_USERS  = [PT_USER_1, PT_USER_2, PT_USER_3]

LOGGER = ::Logger.new(STDOUT)
# LOGGER.level = ::Logger::DEBUG
