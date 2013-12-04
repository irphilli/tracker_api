class PivotalTracker::Client::Epics < PivotalTracker::Collection
  #include PivotalTracker::Searchable

  model PivotalTracker::Client::Epic

  attribute :project_id, type: :integer

  self.collection_method = :get_epics
  self.model_method      = :get_epic

  scopes << :project_id
end
