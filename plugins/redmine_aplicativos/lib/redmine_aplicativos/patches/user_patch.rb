module RedmineAplicativos
  module Patches
    # Patches Redmine's Users dynamically. Adds a relationship
    # User +belongs+ to Position
    module UserPatch
      def self.included(base) # :nodoc:

        # base.send(:include, InstanceMethods)

        # Same as typing in the class
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          safe_attributes 'aplicativo_id'
          belongs_to :aplicativo
        end
      end

      #module InstanceMethods
      #end
    end
  end
end

unless User.included_modules.include?(RedmineAplicativos::Patches::UserPatch)
  User.send(:include, RedmineAplicativos::Patches::UserPatch)
end
