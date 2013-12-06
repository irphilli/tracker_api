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

  class Mock
    def get_project(params={})
      id   = params.fetch("id")
      path = "/projects/#{id}"

      if body = self.data[:projects][id]
        response(
            :path => path,
            :body => body,
        )
      else
        response(
            :path   => path,
            :status => 404,
            :body   => { "error" => "RecordNotFound", "description" => "Not found" },
        )
      end
    end
  end
end
