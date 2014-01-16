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
end
