class PivotalTracker::Client::Iteration < PivotalTracker::Model
  extend PivotalTracker::Attributes

  #PARAMS = %w[id description name]

  identity :id, type: :integer
  attribute :created_at, type: :time
  attribute :finish, type: :time
  attribute :kind, type: :string
  attribute :length, type: :integer
  attribute :number, type: :integer
  attribute :planned, type: :boolean
  attribute :project_id, type: :integer
  attribute :start, type: :time
  attribute :team_strength, type: :float
  attribute :updated_at, type: :time

  assoc_accessor :project

  #private
  #
  #def params
  #  Cistern::Hash.slice(PivotalTracker.stringify_keys(attributes), *PARAMS)
  #end
end
