module TrackerApi
  module Resources
    class Story
      include Virtus.model

      attribute :client

      attribute :accepted_at, DateTime
      attribute :comment_ids, Array[Integer]
      attribute :created_at, DateTime
      attribute :current_state, String # (accepted, delivered, finished, started, rejected, unstarted, unscheduled)
      attribute :deadline, DateTime
      attribute :description, String
      attribute :estimate, Float
      attribute :external_id, String
      attribute :follower_ids, Array[Integer]
      attribute :id, Integer
      attribute :integration_id, Integer
      attribute :kind, String
      attribute :label_ids, Array[Integer]
      attribute :labels, Array[TrackerApi::Resources::Label]
      attribute :name, String
      attribute :owned_by_id, Integer
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
    end
  end
end
