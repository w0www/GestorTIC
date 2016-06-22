require 'redmine'

require 'redmine_positions'

Redmine::Plugin.register :redmine_positions do
  name 'Redmine positions plugin'
  author 'Nick Peelman, Aleksandr Palyan and Imanol Alvarez'
  description 'positions/Offices Plugin.  Icons are from the Silk collection, by FamFamFam'
  version '1.0.1'
  settings({
    :partial => 'settings/redmine_positions_settings',
    :default => {
      :role_for_assign_to_all => "3",
      :use_assign_filter => "0"
    }
  }) 
    
  menu :top_menu, :positions, { :controller => :positions, :action => :index }, :caption => :positions, :if => Proc.new{ User.current.logged? }
  menu :admin_menu, :positions, {:controller => :positions, :action => :index }, :caption => :positions
  permission :view_attachments, {:attachments => [:edit,:show, :download, :thumbnail, :upload, :update, :destroy]}

  project_module :positions do |map|
    map.permission :view_positions, { :positions => [:index, :show] }
    map.permission :add_positions, { :positions => :new }
    map.permission :edit_positions, { :positions => :edit }
    map.permission :delete_positions, { :positions => :delete }
    map.permission :add_issue_to_position, { :positions => :addissue }
    map.permission :remove_issue_from_position, { :positions => :removeissue }
  end

end
