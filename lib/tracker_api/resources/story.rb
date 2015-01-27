module TrackerApi
  module Resources
    class Story
      include TrackerApi::Resources::Base

      attribute :client

      attribute :accepted_at, DateTime
      attribute :comment_ids, Array[Integer]
      attribute :created_at, DateTime
      attribute :current_state, String # (accepted, delivered, finished, started, rejected, planned, unstarted, unscheduled)
      attribute :deadline, DateTime
      attribute :description, String
      attribute :estimate, Float
      attribute :external_id, String
      attribute :follower_ids, Array[Integer]
      attribute :integration_id, Integer
      attribute :kind, String
      attribute :label_ids, Array[Integer]
      attribute :labels, Array[TrackerApi::Resources::Label]
      attribute :name, String
      attribute :owned_by_id, Integer # deprecated!
      attribute :owner_ids, Array[Integer]
      attribute :owners, Array[TrackerApi::Resources::Person]
      attribute :planned_iteration_number, Integer
      attribute :project_id, Integer
      attribute :requested_by_id, Integer
      attribute :story_type, String # (feature, bug, chore, release)
      attribute :task_ids, Array[Integer]
      attribute :tasks, Array[TrackerApi::Resources::Task]
      attribute :updated_at, DateTime
      attribute :url, String

      # @return [String] Comma separated list of labels.
      def label_list
        @label_list ||= labels.collect(&:name).join(',')
      end

      # Provides a list of all the activity performed on the story.
      #
      # @param [Hash] params
      # @return [Array[Activity]]
      def activity(params = {})
        Endpoints::Activity.new(client).get_story(project_id, id, params)
      end

      # @param [Hash] params
      # @return [Array[Task]]
      def tasks(params = {})
        if @tasks.any?
          @tasks
        else
          @tasks = Endpoints::Tasks.new(client).get(project_id, id, params)
        end
      end

      # Save changes to an existing Story.
      def save
        raise ArgumentError, 'Can not update a story with an unknown project_id.' if project_id.nil?

        Endpoints::Story.new(client).update(self, just_changes)

        changes_applied
      end
    end
  end
end
