class PivotalTracker::Client::Story < PivotalTracker::Model
  extend PivotalTracker::Attributes

  #PARAMS = %w[id description name]

  identity :id, type: :integer
  attribute :accepted_at, type: :time
  attribute :comment_ids, type: :array
  attribute :created_at, type: :time
  attribute :current_state, type: :string # (accepted, delivered, finished, started, rejected, unstarted, unscheduled)
  attribute :deadline, type: :time
  attribute :description, type: :string
  attribute :estimate, type: :float
  attribute :external_id, type: :string
  attribute :follower_ids, type: :array
  attribute :integration_id, type: :integer
  attribute :kind, type: :string
  attribute :labels, type: :array
  attribute :name, type: :string
  attribute :owned_by_id, type: :integer
  attribute :planned_iteration_number, type: :integer
  attribute :project_id, type: :integer
  attribute :requested_by_id, type: :integer
  attribute :story_type, type: :string # (feature, bug, chore, release)
  attribute :task_ids, type: :array
  attribute :updated_at, type: :time
  attribute :url, type: :string

  assoc_accessor :project
  assoc_accessor :iteration

  #private
  #
  #def params
  #  Cistern::Hash.slice(PivotalTracker.stringify_keys(attributes), *PARAMS)
  #end
end
