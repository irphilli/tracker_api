class PivotalTracker::Client
  class Real
    def get_epics(params={})
      project_id = params.fetch("project_id")

      request(
          :method => :get,
          :path   => "/projects/#{project_id}/epics",
      )
    end
  end

  #class Mock
  #  def get_epics(params={})
  #    page(params, :epics, "/epics.json", "epics")
  #  end
  #end
end
