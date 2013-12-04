ENV['MOCK_PIVOTAL_TRACKER'] ||= 'true'

#Bundler.require(:test)

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'
require 'pivotal_tracker'
require File.expand_path('../../lib/pivotal_tracker', __FILE__)

Dir[File.expand_path('../{support,shared}/**/*.rb', __FILE__)].each {|f| require f}

if ENV['MOCK_PIVOTAL_TRACKER'] == 'true'
  #PivotalTracker::Client.mock!
end

Cistern.formatter = Cistern::Formatter::AwesomePrint
