class PivotalTracker::Client::Project < PivotalTracker::Model
  extend PivotalTracker::Attributes

  PARAMS = %w[id enable_planned_mode description profile_content number_of_done_iterations_to_show public bugs_and_chores_are_estimatable week_start_day start_date point_scale enable_incoming_emails velocity_averaged_over name initial_velocity point_scale_is_custom iteration_length enable_following atom_enabled enable_tasks]

  identity :id, type: :integer
  attribute :account_id, type: :integer
  attribute :atom_enabled, type: :boolean
  attribute :bugs_and_chores_are_estimatable, type: :boolean
  attribute :created_at, type: :time
  attribute :current_iteration_number, type: :integer
  attribute :description, type: :string
  attribute :enable_following, type: :boolean
  attribute :enable_incoming_emails, type: :boolean
  attribute :enable_planned_mode, type: :boolean
  attribute :enable_tasks, type: :boolean
  attribute :has_google_domain, type: :boolean
  attribute :initial_velocity, type: :integer
  attribute :iteration_length, type: :integer
  attribute :kind, type: :string
  attribute :name, type: :string
  attribute :number_of_done_iterations_to_show, type: :integer
  attribute :point_scale, type: :string
  attribute :point_scale_is_custom, type: :boolean
  attribute :profile_content, type: :string
  attribute :public, type: :boolean
  attribute :start_date, type: :time
  attribute :start_time, type: :time
  attribute :updated_at, type: :time
  attribute :velocity_averaged_over, type: :integer
  attribute :version, type: :integer
  attribute :week_start_day, type: :string
  attribute :time_zone, type: :hash

  #assoc_accessor :time_zone

  # @return [PivotalTracker::Client::Epics] epics associated with this project
  def epics
    requires :identity
    data = connection.get_epics("project_id" => self.identity).body

    connection.epics.load(data)
  end

  private

  def params
    Cistern::Hash.slice(PivotalTracker.stringify_keys(attributes), *PARAMS)
  end
end
