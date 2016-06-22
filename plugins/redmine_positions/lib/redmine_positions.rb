# Set up autoload of patches
def apply_patch(&block)
  ActionDispatch::Callbacks.to_prepare(&block)
end

apply_patch do
  ## Redmine dependencies
  require_dependency 'issue'
  require_dependency 'application_controller'
  require_dependency 'query'
  require_dependency 'user'
  require_dependency 'redmine/helpers/time_report'
  
  # Redmine positions Patches
  require_dependency 'redmine_positions/patches/issue_patch'
  require_dependency 'redmine_positions/patches/application_controller_patch'
  require_dependency 'redmine_positions/patches/issue_query_patch'
  require_dependency 'redmine_positions/patches/time_report_patch'

  # Redmine Users Patches
  require_dependency 'redmine_positions/patches/user_patch'

  # Redmine positions Hooks
  require_dependency 'redmine_positions/hooks/add_position_field'
end
