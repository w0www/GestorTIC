module RedminePositions
  module Patches
    # Patches Redmine's Users dynamically. Adds a relationship
    # User +belongs+ to Position
    module UserPatch
      def self.included(base) # :nodoc:

        # base.send(:include, InstanceMethods)

        # Same as typing in the class
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          safe_attributes 'position_id'
          belongs_to :position
        end
      end

      #module InstanceMethods
      #end
    end
  end
end

unless User.included_modules.include?(RedminePositions::Patches::UserPatch)
  User.send(:include, RedminePositions::Patches::UserPatch)
end
