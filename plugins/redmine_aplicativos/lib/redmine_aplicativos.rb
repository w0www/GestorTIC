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
  require_dependency 'redmine_aplicativos/patches/issue_patch'
  require_dependency 'redmine_aplicativos/patches/application_controller_patch'
  require_dependency 'redmine_aplicativos/patches/issue_query_patch'
  require_dependency 'redmine_aplicativos/patches/time_report_patch'

  # Redmine Users Patches
  require_dependency 'redmine_aplicativos/patches/user_patch'

  # Redmine positions Hooks
  require_dependency 'redmine_aplicativos/hooks/add_aplicativo_field'
end
