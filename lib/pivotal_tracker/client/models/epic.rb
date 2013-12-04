class PivotalTracker::Client::Epic < PivotalTracker::Model
  extend PivotalTracker::Attributes

  PARAMS = %w[id description name]

  identity :id, type: :integer
  attribute :created_at, type: :time
  attribute :description, type: :string
  attribute :kind, type: :string
  attribute :label, type: :hash
  attribute :name, type: :string
  attribute :project_id, type: :integer
  attribute :updated_at, type: :time
  attribute :url, type: :string

  #assoc_accessor :label
  assoc_accessor :project

  private

  def params
    Cistern::Hash.slice(PivotalTracker.stringify_keys(attributes), *PARAMS)
  end
end
