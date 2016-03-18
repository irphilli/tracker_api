require 'virtus'
# if Virtus::Attribute::NullifyBlank.method_defined?(:coerce)
#   require 'virtus/attribute/nullify_blank'
# else
#   raise """
#   WARNING: The above monkey patch can't be applied as expected.
#   See discussion here: https://github.com/dashofcode/tracker_api/commit/27599e7e2169776c32bbff8c972a31b930452879
#   """
# end
require 'virtus/dirty_attribute'

module TrackerApi
  module Resources
    module Shared
      module Base
        def self.included(base)
          base.class_eval do
            include Virtus.model#(nullify_blank: true)
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
