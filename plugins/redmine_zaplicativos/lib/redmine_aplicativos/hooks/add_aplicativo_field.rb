module RedmineAplicativos
  module Hooks
    class AddAplicativoField < Redmine::Hook::ViewListener

      # Renders the Positions
      #
      # Context:
      # * :issue => Issue being rendered
      # * :user => User being rendered
      #
      def view_issues_show_description_bottom(context = {})
        if has_permission?(context)
          context[:controller].send(:render_to_string, {
            :partial => "issues/aplicativos",
            :locals => context
          })
        else
          return ''
        end
      end

      def controller_issues_new_before_save(context = {})
        set_aplicativos_on_issue(context)
      end

      def controller_issues_edit_before_save(context = {})
        set_aplicativos_on_issue(context)
      end

      def controller_issues_bulk_edit_before_save(context = {})
        set_aplicativos_on_issue(context)
      end

      def view_layouts_base_html_head(context = {})
        stylesheet_link_tag 'aplicativos', :plugin => 'redmine_aplicativos'
      end


      def view_account_left_bottom(context = {})
          context[:controller].send(:render_to_string, {
            :partial => "users/show_aplicativo",
            :locals => context
          })
      end

      def view_issues_bulk_edit_details_bottom(context = {})
        if has_permission?(context)
          context[:controller].send(:render_to_string, {
            :partial => "issues/new/form3",
            :locals => context
          })
        else
          return ''
        end
      end

      def view_issues_form_details_bottom(context = {})
        if has_permission?(context)
          context[:controller].send(:render_to_string, {
            :partial => "issues/new/form3",
            :locals => context
          })
        else
          return ''
        end
      end




    private
      def protect_against_forgery?
        false
      end

      def has_permission?(context)
        context[:project] && context[:project].module_enabled?('aplicativos') && User.current.allowed_to?(:view_aplicativos, context[:project])
      end

      def set_aplicativos_on_issue(context)
        if has_permission?(context)
          if context[:params] && context[:params][:issue] && context[:params][:issue][:aplicativo_ids] != [""]
            array_aplicativos = context[:params][:issue][:aplicativo_ids] - [""]
            # Iteramos por el array de oficinas y las introducimos a los departamentos de la issue
            for a in array_aplicativos
              context[:issue].aplicativos << Aplicativo.find(a.to_i)
            end
          end
        else
          return ''
        end
      end
    end
  end
end
