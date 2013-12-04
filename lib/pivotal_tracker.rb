require 'pivotal_tracker/version'

# dependencies
require 'addressable/uri'
require 'cistern'
require 'faraday'
require 'faraday_middleware'
# stdlib
require 'forwardable'
require 'logger'
require 'time'
require 'yaml'

module PivotalTracker
  autoload :Attributes, 'pivotal_tracker/attributes'
  autoload :Error, 'pivotal_tracker/error'
  autoload :Client, 'pivotal_tracker/client'
  autoload :Searchable, 'pivotal_tracker/searchable'
  autoload :Logger, 'pivotal_tracker/logger'
  autoload :Model, 'pivotal_tracker/model'
  autoload :Collection, 'pivotal_tracker/collection'

  def self.defaults
    @defaults ||= if File.exists?(File.expand_path('~/.pivotal_tracker'))
                    YAML.load_file(File.expand_path('~/.pivotal_tracker'))
                  else
                    {}
                  end
  end

  def self.paging_parameters(options={})
    if url = options['url']
      uri = Addressable::URI.parse(url)
      uri.query_values
    else
      Cistern::Hash.slice(options, 'offset', 'limit')
    end
  end

  def self.uuid
    [8, 4, 4, 4, 12].map { |i| Cistern::Mock.random_hex(i) }.join('-')
  end

  def self.stringify_keys(hash)
    hash.inject({}) { |r, (k, v)| r.merge(k.to_s => v) }
  end

  def self.symbolize_keys(hash)
    hash.inject({}) { |r, (k, v)| r.merge(k.to_sym => v) }
  end

  def self.blank?(string)
    string.nil? || string == ''
  end
end
