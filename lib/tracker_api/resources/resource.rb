require 'dry-struct'

module TrackerApi
  module Resources
    # Base class for all resources
    class Resource < Dry::Struct
      constructor_type :schema

      include Dry::Equalizer(:id)

      attribute :id, Types::Coercible::Int
    end
  end
end
