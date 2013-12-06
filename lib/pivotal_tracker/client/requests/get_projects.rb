class PivotalTracker::Client
  class Real
    def get_projects(params={})
      request(
          :method  => :get,
          :path    => "/projects",
      )
    end
  end

  class Mock
    def get_projects(params={})
      collection(params, :projects, "/projects", "projects")
    end
  end
end
