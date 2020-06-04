# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tracker_api/version'

Gem::Specification.new do |spec|
  spec.name        = 'tracker_api'
  spec.version     = TrackerApi::VERSION
  spec.authors     = ['Forest Carlisle']
  spec.email       = ['forestcarlisle@gmail.com']
  spec.summary     = %q{API client for the Pivotal Tracker v5 API}
  spec.description = %q{This gem allows you to easily use the Pivotal Tracker v5 API.}
  spec.homepage    = 'https://github.com/dashofcode/tracker_api'
  spec.license     = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'vcr'
  # spec.add_development_dependency 'minitest-byebug'

  spec.add_dependency 'addressable'
  spec.add_dependency 'virtus'
  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'excon'
  spec.add_dependency 'equalizer'
  spec.add_dependency 'representable'
  spec.add_dependency 'multi_json'
  spec.add_dependency 'mimemagic'
end
