# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pivotal_tracker/version'

Gem::Specification.new do |spec|
  spec.name          = 'pivotal_tracker'
  spec.version       = PivotalTracker::VERSION
  spec.authors       = ['Forest Carlisle']
  spec.email         = ['forestcarlisle@gmail.com']
  spec.description   = %q{API client for the Pivotal Tracker v5 API}
  spec.summary       = %q{API client for the Pivotal Tracker v5 API}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'multi_json'

  spec.add_dependency 'addressable'
  spec.add_dependency 'cistern', '~> 0.4.0'
  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday_middleware'
end
