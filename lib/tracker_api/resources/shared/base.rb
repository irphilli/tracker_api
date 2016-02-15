require 'virtus'
require 'virtus/attribute/nullify_blank'
require 'virtus/dirty_attribute'

module TrackerApi
  module Resources
    module Shared
      module Base
        def self.included(base)
          base.class_eval do
            include Virtus.model(nullify_blank: true)
            include Virtus::DirtyAttribute
            include Virtus::DirtyAttribute::InitiallyClean

            include Equalizer.new(:id)

            attribute :id, Integer
          end
        end
      end
    end
  end
end
