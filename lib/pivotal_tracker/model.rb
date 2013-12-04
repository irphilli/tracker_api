module PivotalTracker
# @abstract subclass and implement {#save!} and {#destroy!}
  class Model < Cistern::Model
    attr_accessor :errors

    # @abstract override in subclass
    # @raise [PivotalTracker::Error] if unsuccessful
    def save!
      raise NotImplementError
    end

    # calls {#save!} and sets {#errors} if unsuccessful and applicable
    # @return [PivotalTracker::Model] self, regardless of success
    def save
      save!
    rescue PivotalTracker::Error => e
      self.errors = e.response[:body]["details"].inject({}) { |r, (k, v)| r.merge(k => v.map { |e| e["type"] || e["description"] }) } rescue nil
      self
    end

    def destroyed?
      !self.reload
    end

    def destroy
      destroy!
    rescue PivotalTracker::Error
      false
    end
  end
end
