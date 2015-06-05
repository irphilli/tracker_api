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
      attribute :current_velocity, Integer
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

      # @return [String] comma separated list of labels
      def label_list
        @label_list ||= labels.collect(&:name).join(',')
      end

      # @param [Hash] params
      # @return [Array[Epic]] epics associated with this project
      def epics(params={})
        raise ArgumentError, 'Expected @epics to be an Array' unless @epics.is_a? Array
        return @epics unless @epics.empty?

        @epics = Endpoints::Epics.new(client).get(id, params)
      end

      # @param [Hash] params
      # @option params [String] :scope Restricts the state of iterations to return.
      #   If not specified, it defaults to all iterations including done.
      #   Valid enumeration values: done, current, backlog, current_backlog.
      # @option params [Integer] :number The iteration to retrieve, starting at 1
      # @option params [Integer] :offset The offset of first iteration to return, relative to the
      #   set of iterations specified by 'scope', with zero being the first iteration in the scope.
      # @option params [Integer] :limit The number of iterations to return relative to the offset.
      # @return [Array[Iteration]] iterations associated with this project
      def iterations(params = {})
        if params.include?(:number)
          number = params[:number].to_i
          raise ArgumentError, ':number must be > 0' unless number > 0

          params = params.merge(auto_paginate: false, limit: 1)
          params.delete(:number)

          offset          = number - 1
          params[:offset] = offset if offset > 0
        end

        Endpoints::Iterations.new(client).get(id, params)
      end

      # @param [Hash] params
      # @option params [String] :with_label A label name which all returned stories must match.
      # @option params [String] :with_state A story's current_state which all returned stories must match.
      #   Valid enumeration values: accepted, delivered, finished, started, rejected, unstarted, unscheduled
      # @option params [String] :filter This parameter supplies a search string;
      #   only stories that match the search criteria are returned.
      #   Cannot be used together with any other parameters except limit and offset.
      #   ex) state:started requester:OWK label:"jedi stuff" keyword
      # @option params [Integer] :offset With the first story in your priority list as 0,
      #   the index of the first story you want returned.
      # @option params [Integer] :limit The number of stories you want returned.
      # @return [Array[Story]] stories associated with this project
      def stories(params = {})
        Endpoints::Stories.new(client).get(id, params)
      end

      # @param [Hash] params
      # @return [Array[ProjectMembership]] memberships of this project
      def memberships(params = {})
        Endpoints::Memberships.new(client).get(id, params)
      end

      # Provides a list of all the activity performed on a project.
      #
      # @param [Hash] params
      # @return [Array[Activity]]
      def activity(params = {})
        Endpoints::Activity.new(client).get_project(id, params)
      end

      # @param [Fixnum] story_id id of story to get
      # @return [Story] story with given id
      def story(story_id)
        Endpoints::Story.new(client).get(id, story_id)
      end

      # @param [Hash] params attributes to create the story with
      # @return [Story] newly created Story
      def create_story(params)
        Endpoints::Story.new(client).create(id, params)
      end

      # @param [Hash] params attributes to add a member; must have at least email or user_id
      # @return [ProjectMembership] member that was added to project
      def add_membership(params)
        Endpoints::Memberships.new(client).add(id, params)
      end
    end
  end
end
