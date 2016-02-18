# @source: https://github.com/ahawkins/virtus-dirty_attribute
module Virtus
  module DirtyAttribute
    class Session
      attr_reader :subject

      def initialize(subject)
        @subject = subject
      end

      def original_attributes
        @_original_attributes ||= get_original_attributes(subject).dup
      end

      def dirty_attributes
        @_dirty_attributes ||= {}
      end

      def dirty!(name, value)
        dirty_attributes[name] = value
      end

      def attribute_clean!(name)
        dirty_attributes.delete name
        original_attributes.delete name
      end

      def dirty?(name = nil)
        name ? dirty_attributes.key?(name) : dirty_attributes.any?
      end

      def clean!
        original_attributes.clear
        dirty_attributes.clear
      end

      private

      # Get the original values from the instance variable directly and not
      # the possibly overridden accessor.
      #
      # This allows for accessors that are created to provide lazy loading
      # of external resources.
      #
      # Whenever something is loaded from the server is should be marked clean.
      def get_original_attributes(subject)
        subject.class.attribute_set.each_with_object({}) do |attribute, attributes|
          name = attribute.name
          attributes[name] = subject.instance_variable_get("@#{name}")
        end
      end
    end
  end
end
