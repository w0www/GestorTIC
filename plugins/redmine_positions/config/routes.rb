RedmineApp::Application.routes.draw do
  resources :positions do
    get 'members/autocomplete', :to => 'positions#autocomplete_for_user', :as => :members_autocomplete
    post 'adduser', :to => 'positions#adduser', :as => :add_member
    delete 'removeuser/:user_id', :to => 'positions#removeuser', :as => :remove_member
    get 'positions/download/:id', :to => 'positions#download', :as => :download_attachment
  end

  post 'issues/:issue_id/positions', :to => 'positions#addissue', :as => :issue_add_position
  get 'positions/:id/:attachment_id/delete' => 'positions#removeattachment', :as => :position_remove_attachment, :source => 'attachment'
  delete 'issues/:issue_id/positions/:position_id' => 'positions#removeissue', :as => :issue_remove_position, :source => 'issue'
  delete 'positions/:position_id/issues/:issue_id' => 'positions#removeissue', :as => :position_remove_issue, :source => 'position'
end
