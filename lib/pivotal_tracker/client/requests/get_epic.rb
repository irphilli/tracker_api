class PivotalTracker::Client
  class Real
    def get_epic(params={})
      project_id = params.fetch("project_id")
      id         = params.fetch("id")

      request(
          :method => :get,
          :path   => "/projects/#{project_id}/epics/#{id}"
      )
    end
  end

  class Mock
    def get_epic(params={})
      project_id = params.fetch("project_id")
      id         = params.fetch("id")
      path       = "/projects/#{project_id}/epics/#{id}"

      if body = self.data[:epics][id]
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
