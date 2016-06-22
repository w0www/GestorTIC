module RedmineAplicativos
  module Patches
    # Patches Redmine's Issues dynamically. Adds a relationship
    # Issue +has_many+ to Issueaplicativo
    module IssuePatch
      def self.included(base) # :nodoc:

        base.send(:include, InstanceMethods)

        # Same as typing in the class
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          has_and_belongs_to_many :aplicativos, :join_table => "issue_has_aplicativos"
          before_create :default_aplicativos
          alias_method_chain :assignable_users, :filter
        end

      end

      module InstanceMethods
        def assignable_users_with_filter
          assign_filter_allow = Setting.plugin_redmine_aplicativos['use_assign_filter'].to_i == 1
          assign_filter_role = Role.find(Setting.plugin_redmine_aplicativos['role_for_assign_to_all']) if assign_filter_allow
          if assign_filter_allow &&
              tracker.is_in_roadmap && new_record? &&
              !User.current.roles_for_project(project).include?(assign_filter_role)
            users = project.members.select {|m| m.roles.detect {|role| role == assign_filter_role}}.collect {|m| m.user}.sort
            users << author if author
            users.uniq.sort
          else
            assignable_users_without_filter
          end
        end
        
        def default_aplicativos
          if aplicativos.empty? && parent_issue_id && p = Issue.find_by_id(parent_issue_id)
            self.aplicativos = p.aplicativos
          elsif aplicativos.empty?
            self.aplicativos = User.current.aplicativos
          end
        end
      end
    end
  end
end

unless Issue.included_modules.include?(RedmineAplicativos::Patches::IssuePatch)
  Issue.send(:include, RedmineAplicativos::Patches::IssuePatch)
end