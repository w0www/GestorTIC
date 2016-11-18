RedmineApp::Application.routes.draw do
  resources :aplicativos do
    get 'members/autocomplete', :to => 'aplicativos#autocomplete_for_user', :as => :members_autocomplete
    post 'adduser', :to => 'aplicativos#adduser', :as => :add_member
    delete 'removeuser/:user_id', :to => 'aplicativos#removeuser', :as => :remove_member
    get 'aplicativos/download/:id', :to => 'aplicativos#download', :as => :download_attachment
  end
  post 'issues/:issue_id/aplicativos', :to => 'aplicativos#addissue', :as => :issue_add_aplicativo
  get 'aplicativos/:id/:attachment_id/delete' => 'aplicativos#removeattachment', :as => :aplicativo_remove_attachment, :source => 'attachment'
  delete 'issues/:issue_id/aplicativos/:aplicativo_id' => 'aplicativos#removeissue', :as => :issue_remove_aplicativo, :source => 'issue'
  delete 'aplicativos/:aplicativo_id/issues/:issue_id' => 'aplicativos#removeissue', :as => :aplicativo_remove_issue, :source => 'aplicativo'
end
