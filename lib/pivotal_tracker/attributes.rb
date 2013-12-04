module PivotalTracker
  module Attributes
    Cistern::Attributes.parsers[:hash] = lambda { |v| v.is_a?(Hash) ? PivotalTracker.symbolize_keys(v) : {} }

    def assoc_reader(name, options={})
      assoc_key  = options[:key] || "#{name}_id"
      collection = options[:collection] || "#{name}s"
      define_method(name) do
        if assoc_id = self.send(assoc_key)
          self.connection.send(collection).get(assoc_id)
        else
          self.instance_variable_get("@#{name}")
        end
      end
    end

    def assoc_writer(name, options={})
      assoc_key = options[:key] || "#{name}_id"
      define_method("#{name}=") do |assoc|
        if assoc.is_a?(Cistern::Model)
          self.send("#{assoc_key}=", assoc.identity)
        else
          self.instance_variable_set("@#{name}", assoc)
        end
      end
    end

    def assoc_accessor(name, options={})
      assoc_reader(name, options)
      assoc_writer(name, options)
    end

    # TODO: collection
  end
end
