module TrackerApi
  module Resources
    class Project
      include Virtus.model

      attribute :client

      attribute :account, TrackerApi::Resources::Account
      attribute :account_id, Integer
      attribute :atom_enabled, Boolean
      attribute :bugs_and_chores_are_estimatable, Boolean
      attribute :created_at, DateTime
      attribute :current_iteration_number, Integer
      attribute :description, String
      attribute :enable_following, Boolean
      attribute :enable_incoming_emails, Boolean
      attribute :enable_planned_mode, Boolean
      attribute :enable_tasks, Boolean
      attribute :epic_ids, Array[Integer]
      attribute :epics, Array[TrackerApi::Resources::Epic]
      attribute :has_google_domain, Boolean
      attribute :id, Integer
      attribute :initial_velocity, Integer
      attribute :iteration_length, Integer
      attribute :kind, String
      attribute :label_ids, Array[Integer]
      attribute :labels, Array[TrackerApi::Resources::Label]
      attribute :name, String
      attribute :number_of_done_iterations_to_show, Integer
      attribute :point_scale, String
      attribute :point_scale_is_custom, Boolean
      attribute :profile_content, String
      attribute :public, Boolean
      attribute :start_date, DateTime
      attribute :start_time, DateTime
      attribute :time_zone, TrackerApi::Resources::TimeZone
      attribute :updated_at, DateTime
      attribute :velocity_averaged_over, Integer
      attribute :version, Integer
      attribute :week_start_day, String

      # @return [TrackerApi::Client::Epics] epics associated with this project
      #def epics
      #  requires :identity
      #  data = connection.get_epics(self.identity).body
      #
      #  connection.epics.load(data)
      #end

      # @param [Hash] options
      # @option options [String] :scope ('') Restricts the state of iterations to return.
      #   If not specified, it defaults to all iterations including done.
      #   Valid enumeration values: done, current, backlog, current_backlog.
      # @option options [Integer] :offset The offset of first iteration to return, relative to the
      #   set of iterations specified by 'scope', with zero being the first iteration in the scope.
      # @option options [Integer] :limit The number of iterations to return relative to the offset.
      # @return [Iterations] iterations associated with this project
      #def iterations(options = {})
      #  requires :identity
      #
      #  data = connection.get_iterations(self.identity, options).body
      #
      #  connection.iterations.load(data)
      #end

      # @return [Iteration] current iteration associated with this project
      #def current_iteration
      #  iterations(scope: 'current').first
      #end
    end
  end
end
