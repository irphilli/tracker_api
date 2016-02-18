module TrackerApi
  module Resources
    module Shared
      class Collection < Array
        def <<(item)
          warn """
            WARNING: Direct mutation of an attribute value skips coercion
            and dirty tracking. Please use direct assignment or the
            specialized add_* methods to get expected behavior.
            https://github.com/solnic/virtus#important-note-about-member-coercions
            """
          super
        end
      end
    end
  end
end
