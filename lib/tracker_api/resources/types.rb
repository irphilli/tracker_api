require 'dry-types'

module TrackerApi
  module Resources
    module Types
      include Dry::Types.module

      # Statuses = Types::Strict::String.enum('draft', 'published', 'archived')
    end
  end
end
