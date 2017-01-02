module TrackerApi
  module Resources
    class StoryTransition
      include Shared::Base

      attribute :state, String
      attribute :occurred_at, DateTime
    end
  end
end
