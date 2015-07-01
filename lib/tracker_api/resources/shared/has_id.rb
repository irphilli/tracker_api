require 'virtus'

module TrackerApi
  module Resources
    module Shared
      module HasId
        def self.included(base)
          base.class_eval do
            include Virtus.model
            include Equalizer.new(:id)

            attribute :id, Integer
          end
        end
      end
    end
  end
end
