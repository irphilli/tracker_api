require 'tracker_api/version'

# dependencies
require 'faraday'
require 'faraday_middleware'
require 'pathname'
require 'mimemagic'

if defined?(ActiveSupport)
  require 'active_support/core_ext/object/blank'
else
  require 'core_ext/object/blank'
end
require 'equalizer'

require 'multi_json'
require 'representable/json'

# stdlib
require 'addressable/uri'
require 'forwardable'
require 'logger'

MultiJson.load_options = {:mode => :compat}
MultiJson.dump_options = {:mode => :compat}

module TrackerApi
  autoload :Error, 'tracker_api/error'
  autoload :Client, 'tracker_api/client'
  autoload :Logger, 'tracker_api/logger'
  autoload :FileUtility, 'tracker_api/file_utility'

  module Errors
    class UnexpectedData < StandardError; end
    class ClientError < Error; end
    class ServerError < Error; end
  end

  module Endpoints
    autoload :Activity, 'tracker_api/endpoints/activity'
    autoload :Blockers, 'tracker_api/endpoints/blockers'
    autoload :Epic, 'tracker_api/endpoints/epic'
    autoload :Epics, 'tracker_api/endpoints/epics'
    autoload :Iteration, 'tracker_api/endpoints/iteration'
    autoload :Iterations, 'tracker_api/endpoints/iterations'
    autoload :Labels, 'tracker_api/endpoints/labels'
    autoload :Me, 'tracker_api/endpoints/me'
    autoload :Memberships, 'tracker_api/endpoints/memberships'
    autoload :Notifications, 'tracker_api/endpoints/notifications'
    autoload :Project, 'tracker_api/endpoints/project'
    autoload :Projects, 'tracker_api/endpoints/projects'
    autoload :Workspace, 'tracker_api/endpoints/workspace'
    autoload :Workspaces, 'tracker_api/endpoints/workspaces'
    autoload :Search, 'tracker_api/endpoints/search'
    autoload :Stories, 'tracker_api/endpoints/stories'
    autoload :Story, 'tracker_api/endpoints/story'
    autoload :StoryOwners, 'tracker_api/endpoints/story_owners'
    autoload :Task, 'tracker_api/endpoints/task'
    autoload :Tasks, 'tracker_api/endpoints/tasks'
    autoload :Comments, 'tracker_api/endpoints/comments'
    autoload :Comment, 'tracker_api/endpoints/comment'
    autoload :Webhook, 'tracker_api/endpoints/webhook'
    autoload :Webhooks, 'tracker_api/endpoints/webhooks'
    autoload :StoryTransitions, 'tracker_api/endpoints/story_transitions'
    autoload :Attachment, 'tracker_api/endpoints/attachment'
    autoload :Attachments, 'tracker_api/endpoints/attachments'
    autoload :Releases, 'tracker_api/endpoints/releases'
    autoload :Release, 'tracker_api/endpoints/release'
    autoload :Review, 'tracker_api/endpoints/review'
    autoload :Reviews, 'tracker_api/endpoints/reviews'
  end

  module Resources
    module Shared
      autoload :Base, 'tracker_api/resources/shared/base'
      autoload :Collection, 'tracker_api/resources/shared/collection'
    end
    autoload :Activity, 'tracker_api/resources/activity'
    autoload :Account, 'tracker_api/resources/account'
    autoload :Blocker, 'tracker_api/resources/blocker'
    autoload :Change, 'tracker_api/resources/change'
    autoload :Epic, 'tracker_api/resources/epic'
    autoload :EpicsSearchResult, 'tracker_api/resources/epics_search_result'
    autoload :Iteration, 'tracker_api/resources/iteration'
    autoload :Me, 'tracker_api/resources/me'
    autoload :MembershipSummary, 'tracker_api/resources/membership_summary'
    autoload :Notification, 'tracker_api/resources/notification'
    autoload :Label, 'tracker_api/resources/label'
    autoload :Person, 'tracker_api/resources/person'
    autoload :PrimaryResource, 'tracker_api/resources/primary_resource'
    autoload :Project, 'tracker_api/resources/project'
    autoload :ProjectMembership, 'tracker_api/resources/project_membership'
    autoload :Workspace, 'tracker_api/resources/workspace'
    autoload :SearchResultContainer, 'tracker_api/resources/search_result_container'
    autoload :StoriesSearchResult, 'tracker_api/resources/stories_search_result'
    autoload :Story, 'tracker_api/resources/story'
    autoload :Task, 'tracker_api/resources/task'
    autoload :TimeZone, 'tracker_api/resources/time_zone'
    autoload :Comment, 'tracker_api/resources/comment'
    autoload :Webhook, 'tracker_api/resources/webhook'
    autoload :StoryTransition, 'tracker_api/resources/story_transition'
    autoload :FileAttachment, 'tracker_api/resources/file_attachment'
    autoload :Release, 'tracker_api/resources/release'
    autoload :CycleTimeDetails, 'tracker_api/resources/cycle_time_details'
    autoload :DailyHistoryContainer, 'tracker_api/resources/daily_history_container'
    autoload :Review, 'tracker_api/resources/review'
    autoload :ReviewType, 'tracker_api/resources/review_type'
  end
end
