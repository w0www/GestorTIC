class AplicativosController < ApplicationController
  unloadable

  include Redmine::SafeAttributes

  helper :members

  def index
    limit = per_page_option
    @aplicativos_count = Aplicativo.count
    @aplicativos_pages = Paginator.new(@aplicativos_count, limit, params['page'])
    @aplicativos = Aplicativo.all
    respond_to do |format|
      format.html { render :template => 'aplicativos/index.html.erb', :layout => !request.xhr? }
    end
  end

  def show
    @aplicativo = Aplicativo.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @members = User.active.where("type <> 'AnonymousUser'")
    @aplicativo = Aplicativo.new
    respond_to do |format|
      format.html 
      format.js do
        render :update do |page|
          page.replace_html "aplicativos", :partial => 'issues/aplicativos', :locals => { :issue => @issue, :project => @project }
        end
      end
    end
  end

  def edit
    @aplicativo = Aplicativo.find(params[:id])
    @members = User.active.where("type <> 'AnonymousUser'")
    respond_to do |format|
      format.html
    end
  end

  def update
    @aplicativo = Aplicativo.find(params[:id])
    respond_to do |format|
      if @aplicativo.update_attributes(aplicativos_params)
        flash[:notice] = l('aplicativo_updated')
        format.html { redirect_to @aplicativo }
      else
        format.html { render :edit }
      end
    end
  end
  
  def addissue
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
    array_aplicativos = params[:aplicativo][:aplicativo_ids] - [""]
    for a in array_aplicativos
      @aplicativo = Aplicativo.find(a.to_i)
      @aplicativo.issues << @issue 
    end
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def removeissue
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
    @aplicativo = Aplicativo.find(params[:aplicativo_id])
    @source = params[:source]
    @aplicativo.issues.delete(@issue)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def adduser
    @aplicativo = Aplicativo.find(params[:aplicativo_id])
    @usuarios_ids = []
    @members = []
    if params[:member] && params[:member] != "" && request.post?
      for u in params[:member]
        @usuarios_ids << u.last
        @members << User.find(u.last)
      end
      @aplicativo.users << @members
    end
    respond_to do |format|
      format.html { redirect_to :controller => 'aplicativos', :action => 'edit', :id => @aplicativo }
      format.js
    end
  end

  def removeuser
    @aplicativo = Aplicativo.find(params[:aplicativo_id])
    @aplicativo.users.delete(User.find(params[:user_id]))
    respond_to do |format|
      format.html { redirect_to :controller => 'aplicativos', :action => 'edit', :id => @aplicativo }
      format.js
    end
  end
  
  def create
    @members = User.active.where("type <> 'AnonymousUser'")
    @aplicativo = Aplicativo.new(aplicativos_params)
    respond_to do |format|
      if @aplicativo.save
        format.html { redirect_to edit_aplicativo_path :id => @aplicativo }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @aplicativo = Aplicativo.find(params[:id])
    respond_to do |format|
      if @aplicativo.destroy
        flash[:notice] = l('aplicativo_removed')
        format.html { redirect_to :controller => 'aplicativos', :action => 'index', :per_page => params[:per_page], :page => params[:page] }
        format.js { render(:update) { |page| page.replace_html "aplicativos", :partial => 'aplicativos/list', :locals => {:aplicativos => @aplicativos } } }
      else
        flash[:notice] = l('aplicativo_not_removed')
        format.html { redirect_to :controller => 'aplicativos', :action => 'index' }
        format.js { render(:update) { |page| page.replace_html "aplicativos", :partial => 'aplicativos/list', :locals => {:aplicativos => @aplicativos } } }          
      end
    end
  end

  def autocomplete_for_user
    @aplicativo = Aplicativo.find(params[:aplicativo_id])
    @users = User.active.like(params[:q]).all(:limit => 100) - @aplicativo.users
    respond_to do |format|
      format.js
    end
  end
  
private
  def find_project
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # Rails 4 Integration.
  def aplicativos_params
    params.require(:aplicativo).permit(:nombre, :codigo,:descripcion)
  end

end
