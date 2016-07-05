module RedmineAplicativos
  module Patches
    # Patches Redmine's Issues dynamically. Adds a relationship
    # Issue +has_many+ to IssueDepartment
    module IssuePatch
      def self.included(base) # :nodoc:

        # Same as typing in the class
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          has_and_belongs_to_many :aplicativos, :join_table => "issue_has_aplicativos"
        end

      end
    end
  end
end

unless Issue.included_modules.include?(RedmineAplicativos::Patches::IssuePatch)
  Issue.send(:include, RedmineAplicativos::Patches::IssuePatch)
end
