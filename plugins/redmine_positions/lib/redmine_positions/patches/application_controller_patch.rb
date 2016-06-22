module RedminePositions
  module Patches
    module ApplicationControllerPatch
      def self.included(base) # :nodoc:
        # Same as typing in the class
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          helper PositionsHelper
        end
      end
    end
  end
end

unless ApplicationController.included_modules.include?(RedminePositions::Patches::ApplicationControllerPatch)
  ApplicationController.send(:include, RedminePositions::Patches::ApplicationControllerPatch)
end
