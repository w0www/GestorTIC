module RedmineAplicativos
  module Patches
    # Patches Redmine's Queries dynamically, adding the Deliverable
    # to the available query columns
    module IssueQueryPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        # Same as typing in the class
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          base.add_available_column(QueryColumn.new(:aplicativos, :sortable => "#{Aplicativo.table_name}.name", :groupable => "#{IssueHasAplicativo.table_name}.aplicativo_id"))

          alias_method_chain :initialize_available_filters, :aplicativos
          alias_method_chain :joins_for_order_statement, :aplicativos
        end

      end

      module InstanceMethods
        def joins_for_order_statement_with_aplicativos(order_options)
          joins = joins_for_order_statement_without_aplicativos(order_options)
          if order_options
            if order_options.include?("#{Aplicativo.table_name}")
              joins = "" if joins.nil?
              joins += " LEFT JOIN #{IssueHasAplicativo.table_name} ON #{IssueHasAplicativo.table_name}.issue_id = #{queried_table_name}.id"
              joins += " LEFT JOIN #{Aplicativo.table_name} ON #{Aplicativo.table_name}.id = #{IssueHasAplicativo.table_name}.aplicativo_id"
            end
          end

          joins
        end

        def sql_for_aplicativo_id_field(field, operator, value)
          db_table = 'issue_has_aplicativos'
          "#{Issue.table_name}.id #{ operator == '=' ? 'IN' : 'NOT IN' } (SELECT #{db_table}.issue_id FROM #{db_table} WHERE " +
            sql_for_field(field, '=', value, db_table, 'aplicativo_id') + ')'
        end

        # Wrapper around the +available_filters+ to add a new Departments filter
        def initialize_available_filters_with_aplicativos
          initialize_available_filters_without_aplicativos
          add_available_filter "aplicativo_id",
            :type => :list_optional, :values => Aplicativo.all().collect { |d| [d.nombre, d.id.to_s] }
        end
      end
    end
  end
end

unless IssueQuery.included_modules.include?(RedmineAplicativos::Patches::IssueQueryPatch)
  IssueQuery.send(:include, RedmineAplicativos::Patches::IssueQueryPatch)
end
