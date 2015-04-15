require 'virtus'
require 'active_support/concern'
require 'active_model'

module TrackerApi
  module Resources
    module Base
      extend ActiveSupport::Concern

      include ActiveModel::Model
      include ActiveModel::Dirty

      included do
        include Virtus.model
        include OverrideAttributes

        attribute :id, Integer

        def initialize(attrs)
          super

          # always reset dirty tracking on initialize
          clear_changes_information
        end

        private

        # @return [Hash] key value pairs for just the changed attributes with their new values.
        def just_changes
          # @see changes in ActiveModel::Dirty in active_model/dirty.rb
          #     { attr => [original value, new value] }
          changes.inject({}) do |h, (k, v)|
            h[k] = v[1]; h;
          end
        end
      end

      module OverrideAttributes
        extend ActiveSupport::Concern

        module ClassMethods
          def attribute(name, type, options = {})
            define_attribute_methods name

            attribute = super
            create_writer_with_dirty_tracking(name)
            attribute
          end

          private

          def create_writer_with_dirty_tracking(name)
            method_str = <<-RUBY
              def #{name}=(value)
                prev_value = #{name}
                new_value  = value
                if prev_value != new_value
                  #{name}_will_change!
                  new_value = super(value)
                end
                new_value
              end
            RUBY

            class_eval method_str, __FILE__, __LINE__ + 1
          end
        end
      end
    end
  end
end
