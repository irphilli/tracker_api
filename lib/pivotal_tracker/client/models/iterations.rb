class PivotalTracker::Client::Iterations < PivotalTracker::Collection
  #include PivotalTracker::Searchable

  model PivotalTracker::Client::Iteration

  attribute :project_id, type: :integer

  self.collection_method = :get_iterations

  scopes << :project_id
end
