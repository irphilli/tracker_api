module TrackerApi
  module Resources
    class Story
      include Shared::HasId

      attribute :client

      attribute :accepted_at, DateTime
      attribute :comment_ids, Array[Integer]
      attribute :comments, Array[Comment]
      attribute :created_at, DateTime
      attribute :current_state, String # (accepted, delivered, finished, started, rejected, planned, unstarted, unscheduled)
      attribute :deadline, DateTime
      attribute :description, String
      attribute :estimate, Float
      attribute :external_id, String
      attribute :follower_ids, Array[Integer]
      attribute :followers, Array[Person]
      attribute :integration_id, Integer
      attribute :kind, String
      attribute :label_ids, Array[Integer]
      attribute :labels, Array[Label]
      attribute :name, String
      attribute :owned_by_id, Integer # deprecated!
      attribute :owner_ids, Array[Integer]
      attribute :owners, Array[Person]
      attribute :planned_iteration_number, Integer
      attribute :project_id, Integer
      attribute :requested_by, Person
      attribute :requested_by_id, Integer
      attribute :story_type, String # (feature, bug, chore, release)
      attribute :task_ids, Array[Integer]
      attribute :tasks, Array[Task]
      attribute :updated_at, DateTime
      attribute :url, String


      class UpdateRepresenter < Representable::Decorator
        include Representable::JSON

        property :follower_ids
        property :name
        property :description
        property :story_type
        property :current_state
        property :estimate
        property :accepted_at
        property :deadline
        property :requested_by_id
        property :owner_ids
        collection :labels, class: Label, decorator: Label::UpdateRepresenter, render_empty: true
        property :integration_id
        property :external_id
      end

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

      # Provides a list of all the comments on the story.
      #
      # @param [Hash] params
      # @return [Array[Comment]]
      def comments(params = {})
        if @comments && @comments.any?
          @comments
        else
          @comments = Endpoints::Comments.new(client).get(project_id, id, params)
        end
      end

      # Provides a list of all the tasks on the story.
      #
      # @param [Hash] params
      # @return [Array[Task]]
      def tasks(params = {})
        if @tasks && @tasks.any?
          @tasks
        else
          @tasks = Endpoints::Tasks.new(client).get(project_id, id, params)
        end
      end

      # Provides a list of all the owners of the story.
      #
      # @param [Hash] params
      # @return [Array[Person]]
      def owners(params = {})
        if @owners && @owners.any?
          @owners
        else
          @owners = Endpoints::StoryOwners.new(client).get(project_id, id, params)
        end
      end

      # @param [Hash] params attributes to create the task with
      # @return [Task] newly created Task
      def create_task(params)
        Endpoints::Task.new(client).create(project_id, id, params)
      end

      # Save changes to an existing Story.
      def save
        raise ArgumentError, 'Can not update a story with an unknown project_id.' if project_id.nil?

        Endpoints::Story.new(client).update(self, UpdateRepresenter.new(self))
      end
    end
  end
end
