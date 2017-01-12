require 'dry-struct'
require_relative 'types'

module TrackerApi

  module Resources
    module Shared
      class BaseDry < Dry::Struct
        constructor_type :schema

        include Dry::Equalizer(:id)

        attribute :id, Types::Coercible::Int
      end
    end
  end
end
