module RedminePositions
  module Hooks
    class AddPositionField < Redmine::Hook::ViewListener

      # Renders the Positions
      #
      # Context:
      # * :issue => Issue being rendered
      # * :user => User being rendered
      #
      def view_issues_form_details_bottom(context = {})
        if has_permission?(context)
          context[:controller].send(:render_to_string, {
            :partial => "issues/new/form2",
            :locals => context
          })
        else
          return ''
        end
      end

      def view_users_form(context = {})
          context[:controller].send(:render_to_string, {
            :partial => "users/new/form2",
            :locals => context
          })
      end

      def view_my_account(context = {})
          context[:controller].send(:render_to_string, {
            :partial => "users/new/form2",
            :locals => context
          })
      end

      def view_account_left_bottom(context = {})
          context[:controller].send(:render_to_string, {
            :partial => "users/show2",
            :locals => context
          })
      end

      def view_issues_bulk_edit_details_bottom(context = {})
        if has_permission?(context)
          context[:controller].send(:render_to_string, {
            :partial => "issues/new/form2",
            :locals => context
          })
        else
          return ''
        end
      end

      def view_issues_show_description_bottom(context = {})
        if has_permission?(context)
          context[:controller].send(:render_to_string, {
            :partial => "issues/positions",
            :locals => context
          })
        else
          return ''
        end
      end

      def controller_issues_new_before_save(context = {})
        set_positions_on_issue(context)
      end

      def controller_issues_edit_before_save(context = {})
        set_positions_on_issue(context)
      end

      def controller_issues_bulk_edit_before_save(context = {})
        set_positions_on_issue(context)
      end

      def view_layouts_base_html_head(context = {})
        stylesheet_link_tag 'positions', :plugin => 'redmine_positions'
      end

    private
      def protect_against_forgery?
        false
      end

      def has_permission?(context)
        context[:project] && context[:project].module_enabled?('positions') && User.current.allowed_to?(:view_positions, context[:project])
      end

      def set_positions_on_issue(context)
        if context[:params] && context[:params][:issue] && context[:params][:issue][:position_ids] != ""
          # Por alguna razon cuando llega a este punto llega siempre un array [""] y luego el resto. (llega porque es multilpe)
            Rails.logger.info "esto es #{context[:params][:issue][:position_ids]}"
            context[:issue].positions << Position.find(context[:params][:issue][:position_ids].to_i)
        end
        return ''
      end
    end
  end
end
