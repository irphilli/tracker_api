module PivotalTracker
  module Searchable
    def self.included(klass)
      klass.send(:extend, PivotalTracker::Searchable::Attributes)
    end

    def search(parameters)
      body = connection.send(self.class.search_request, parameters.merge("type" => self.class.search_type)).body
      if data = body.delete("results")
        collection = self.clone.load(data)
        #collection.merge_attributes(Cistern::Hash.slice(body, "count", "next_page", "previous_page"))
        collection
      end
    end

    module Attributes
      attr_accessor :search_type
      attr_writer :search_request

      def search_request
        @search_request ||= :search
      end
    end
  end
end
