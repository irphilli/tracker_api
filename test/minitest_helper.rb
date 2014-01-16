#Bundler.require(:test)
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'vcr'

require 'pivotal_tracker'
require File.expand_path('../../lib/pivotal_tracker', __FILE__)

Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each {|f| require f}

Cistern.formatter = Cistern::Formatter::AwesomePrint

VCR.configure do |c|
  c.ignore_localhost = true
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.default_cassette_options = { serialize_with: :json }
  c.hook_into :faraday
  c.allow_http_connections_when_no_cassette = true
end
