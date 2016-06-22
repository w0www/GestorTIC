module RedminePositions
  module Patches
    # Patches Redmine's Queries dynamically, adding the Deliverable
    # to the available query columns
    module IssueQueryPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        # Same as typing in the class
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          base.add_available_column(QueryColumn.new(:positions, :sortable => "#{Position.table_name}.name", :groupable => "#{IssueHasPosition.table_name}.position_id"))

          alias_method_chain :initialize_available_filters, :positions
          alias_method_chain :joins_for_order_statement, :positions
        end

      end

      module InstanceMethods
        def joins_for_order_statement_with_positions(order_options)
          joins = joins_for_order_statement_without_positions(order_options)
          if order_options
            if order_options.include?("#{Position.table_name}")
              joins = "" if joins.nil?
              joins += " LEFT JOIN #{IssueHasPosition.table_name} ON #{IssueHasPosition.table_name}.issue_id = #{queried_table_name}.id"
              joins += " LEFT JOIN #{Position.table_name} ON #{Position.table_name}.id = #{IssueHasPosition.table_name}.position_id"
            end
          end

          joins
        end

        def sql_for_position_id_field(field, operator, value)
          db_table = 'issue_has_positions'
          "#{Issue.table_name}.id #{ operator == '=' ? 'IN' : 'NOT IN' } (SELECT #{db_table}.issue_id FROM #{db_table} WHERE " +
            sql_for_field(field, '=', value, db_table, 'position_id') + ')'
        end

        # Wrapper around the +available_filters+ to add a new Positions filter
        def initialize_available_filters_with_positions
          initialize_available_filters_without_positions
          add_available_filter "position_id",
            :type => :list_optional, :values => Position.all().collect { |d| [d.nombre, d.id.to_s] }
        end
      end
    end
  end
end

unless IssueQuery.included_modules.include?(RedminePositions::Patches::IssueQueryPatch)
  IssueQuery.send(:include, RedminePositions::Patches::IssueQueryPatch)
end
