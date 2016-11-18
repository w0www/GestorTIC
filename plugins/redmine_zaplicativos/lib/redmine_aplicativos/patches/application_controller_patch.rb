module RedmineAplicativos
  module Patches
    module ApplicationControllerPatch
      def self.included(base) # :nodoc:
        # Same as typing in the class
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          helper AplicativosHelper
        end
      end
    end
  end
end

unless ApplicationController.included_modules.include?(RedmineAplicativos::Patches::ApplicationControllerPatch)
  ApplicationController.send(:include, RedmineAplicativos::Patches::ApplicationControllerPatch)
end
