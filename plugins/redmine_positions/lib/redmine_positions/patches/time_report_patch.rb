module RedminePositions
  module Patches
    module TimeReportPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        # Same as typing in the class
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development

          alias_method_chain :load_available_criteria, :positions
        end

      end

      module InstanceMethods

        def load_available_criteria_with_positions
          load_available_criteria_without_positions
          @available_criteria["position"] = 
            { :sql => "COALESCE(positions.position_id, '')",
              :joins => "LEFT JOIN issue_has_positions positions on positions.issue_id = #{TimeEntry.table_name}.issue_id",
              :klass => Position,
              :label => :position
            }
          @available_criteria
        end
      end
    end
  end
end

unless Redmine::Helpers::TimeReport.included_modules.include?(RedminePositions::Patches::TimeReportPatch)
  Redmine::Helpers::TimeReport.send(:include, RedminePositions::Patches::TimeReportPatch)
end
