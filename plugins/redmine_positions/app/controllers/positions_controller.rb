class PositionsController < ApplicationController
  unloadable

  include Redmine::SafeAttributes

  helper :members

  def index
    limit = per_page_option
    @positions_count = Position.count
    @positions_pages = Paginator.new(@positions_count, limit, params['page'])
    @positions = Position.all
    respond_to do |format|
      format.html { render :template => 'positions/index.html.erb', :layout => !request.xhr? }
    end
  end

  def show
    @position = Position.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @members = User.active.where("type <> 'AnonymousUser'")
    @position = Position.new
    respond_to do |format|
      format.html 
      format.js do
        render :update do |page|
          page.replace_html "positions", :partial => 'issues/positions', :locals => { :issue => @issue, :project => @project }
        end
      end
    end
  end

  def edit
    @position = Position.find(params[:id])
    @members = User.active.where("type <> 'AnonymousUser'")
    respond_to do |format|
      format.html
    end
  end

  def update
    @position = Position.find(params[:id])
    respond_to do |format|
      if @position.update_attributes(positions_params)
        flash[:notice] = l('position_updated')
        format.html { redirect_to @position }
      else
        format.html { render :edit }
      end
    end
  end
  
  def addissue
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
    @position = Position.find(params[:position][:position_id])
    @position.issues << @issue
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def removeissue
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
    @position = Position.find(params[:position_id])
    @source = params[:source]
    @position.issues.delete(@issue)
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def adduser
    @position = Position.find(params[:position_id])
    @usuarios_ids = []
    @members = []
    if params[:member] && params[:member] != "" && request.post?
      for u in params[:member]
        @usuarios_ids << u.last
        @members << User.find(u.last)
      end
      @position.users << @members
    end
    respond_to do |format|
      format.html { redirect_to :controller => 'positions', :action => 'edit', :id => @position }
      format.js
    end
  end
  
  def removeuser
    @position = Position.find(params[:position_id])
    @position.users.delete(User.find(params[:user_id]))
    respond_to do |format|
      format.html { redirect_to :controller => 'positions', :action => 'edit', :id => @position }
      format.js
    end
  end

  def addaplicativo
    @position = Position.find(params[:position_id])
    @aplicativos_ids = []
    @aplicativs = []
    if params[:aplicativo] && params[:aplicativo] != "" && request.post?
      for a in params[:aplicativo]
        @aplicativos_ids << a.last
        @aplicativs << Aplicativo.find(a.last)
      end
      @position.aplicativos << @aplicativs
    end
    respond_to do |format|
      format.html { redirect_to :controller => 'positions', :action => 'edit', :id => @position }
      format.js
    end
  end
  
  def removeaplicativo
    @position = Position.find(params[:position_id])
    @position.aplicativos.delete(Aplicativo.find(params[:aplicativo_id]))
    respond_to do |format|
      format.html { redirect_to :controller => 'positions', :action => 'edit', :id => @position }
      format.js
    end
  end


  def create
    @members = User.active.where("type <> 'AnonymousUser'")
    @position = Position.new(positions_params)
    respond_to do |format|
      if @position.save
        format.html { redirect_to edit_position_path :id => @position }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @position = Position.find(params[:id])
    respond_to do |format|
      if @position.destroy
        flash[:notice] = l('position_removed')
        format.html { redirect_to :controller => 'positions', :action => 'index', :per_page => params[:per_page], :page => params[:page] }
        format.js { render(:update) { |page| page.replace_html "positions", :partial => 'positions/list', :locals => {:positions => @positions } } }
      else
        flash[:notice] = l('position_not_removed')
        format.html { redirect_to :controller => 'positions', :action => 'index' }
        format.js { render(:update) { |page| page.replace_html "positions", :partial => 'positions/list', :locals => {:positions => @positions } } }          
      end
    end
  end

  def autocomplete_for_user
    @position = Position.find(params[:position_id])
    @users = User.active.like(params[:q]).all(:limit => 100) - @position.users
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
  def positions_params
    params.require(:position).permit(:nombre, :codigo,:descripcion)
  end

end
