class PivotalTracker::Client
  class Real
    def get_project(params={})
      id = params.fetch("id")

      request(
          :method => :get,
          :path   => "/projects/#{id}"
      )
    end
  end
end
