class PivotalTracker::Client
  class Real
    def get_projects(params={})
      request(
          :method  => :get,
          :path    => "/projects",
      )
    end
  end
end
