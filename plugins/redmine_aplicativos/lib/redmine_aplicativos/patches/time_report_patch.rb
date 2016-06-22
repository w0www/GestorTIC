module RedmineAplicativos
  module Patches
    module TimeReportPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        # Same as typing in the class
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          alias_method_chain :load_available_criteria, :aplicativos
        end

      end

      module InstanceMethods

        def load_available_criteria_with_aplicativos
          load_available_criteria_without_aplicativos
          @available_criteria["aplicativo"] = 
            { :sql => "COALESCE(aplicativos.aplicativo_id, '')",
              :joins => "LEFT JOIN issue_has_aplicativos aplicativos on aplicativos.issue_id = #{TimeEntry.table_name}.issue_id",
              :klass => Aplicativo,
              :label => :aplicativo
            }
          @available_criteria
        end
      end
    end
  end
end

unless Redmine::Helpers::TimeReport.included_modules.include?(RedmineAplicativos::Patches::TimeReportPatch)
  Redmine::Helpers::TimeReport.send(:include, RedmineAplicativos::Patches::TimeReportPatch)
end
