require 'redmine'

require 'redmine_aplicativos'

Redmine::Plugin.register :redmine_aplicativos do
  name 'Redmine aplicativos plugin'
  author 'Nick Peelman, Aleksandr Palyan and Imanol Alvarez'
  description 'aplicativos Plugin.  Icons are from the Silk collection, by FamFamFam'
  version '1.0.1'
  settings({
    :partial => 'settings/redmine_aplicativos_settings',
    :default => {
      :role_for_assign_to_all => "3",
      :use_assign_filter => "0"
    }
  }) 
    
  menu :top_menu, :aplicativos, { :controller => :aplicativos, :action => :index }, :caption => :aplicativos, :if => Proc.new{ User.current.logged? }
  menu :admin_menu, :aplicativos, {:controller => :aplicativos, :action => :index }, :caption => :aplicativos
  permission :view_attachments, {:attachments => [:edit,:show, :download, :thumbnail, :upload, :update, :destroy]}

  project_module :aplicativos do |map|
    map.permission :view_aplicativos, { :aplicativos => [:index, :show] }
    map.permission :add_aplicativos, { :aplicativos => :new }
    map.permission :edit_aplicativos, { :aplicativos => :edit }
    map.permission :delete_aplicativos, { :aplicativos => :delete }
    map.permission :add_issue_to_aplicativo, { :aplicativos => :addissue }
    map.permission :remove_issue_from_aplicativo, { :aplicativos => :removeissue }
  end

end
