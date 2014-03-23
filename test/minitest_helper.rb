#Bundler.require(:test)
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'coveralls'
Coveralls.wear!

require 'minitest/byebug' if ENV['DEBUG']
require 'minitest/autorun'
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
PT_USER_1 = { project_id: 1027488, token: '0de3ac29f13082f0c16ed76f3f3f6895' } # trackher1 user
PT_USER_2 = { project_id: 1027492, token: '90a51cef4e7c358b36b4e4cdf0f2dd2a' } # trackher2 user
PT_USER_3 = { project_id: 1027494, token: 'f8aad6b471d1b1eb303d368ef533f622' } # trackher3 user
PT_USERS  = [PT_USER_1, PT_USER_2, PT_USER_3]
