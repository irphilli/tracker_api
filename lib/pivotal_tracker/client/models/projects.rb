class PivotalTracker::Client::Projects < PivotalTracker::Collection
  #include PivotalTracker::Searchable

  model PivotalTracker::Client::Project

  self.collection_method = :get_projects
  self.model_method      = :get_project
end
