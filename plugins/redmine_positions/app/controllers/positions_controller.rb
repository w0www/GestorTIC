class PositionsController < ApplicationController
  unloadable

  include Redmine::SafeAttributes

  helper :members
  helper :attachments

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
      @position.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))  
      @position.attach_saved_attachments 
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

  def removeattachment
    @position = Position.find(params[:id])
    @position.attachments.delete(Attachment.find(params[:attachment_id]))
    respond_to do |format|
      format.html { redirect_to :controller => 'positions', :action => 'show', :id => @position }
      format.js
    end
  end


  def download
    @attachment = Attachment.find(params[:id])
    send_file @attachment.diskfile, :filename => filename_for_content_disposition(@attachment.filename),
                                          :type => detect_content_type(@attachment),
                                          :disposition => disposition(@attachment)
  end


  def filename_for_content_disposition(name)
    request.env['HTTP_USER_AGENT'] =~ %r{(MSIE|Trident|Edge)} ? ERB::Util.url_encode(name) : name
  end

  def detect_content_type(attachment)
    content_type = attachment.content_type
    if content_type.blank? || content_type == "application/octet-stream"
      content_type = Redmine::MimeType.of(attachment.filename)
    end
    content_type.to_s
  end

  def disposition(attachment)
      'attachment'
  end


  def create
    @members = User.active.where("type <> 'AnonymousUser'")
    @position = Position.new(positions_params)
    @position.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))  
    @position.attach_saved_attachments  
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
    params.require(:position).permit(:nombre, :codigo,:direccion,:direccion2,:codigo_postal,:localidad,:territorio,:telefono,:fax,:email_oficina,:telefono_vigilante,
                                        :responsable_sepe,:telefono_responsable_sepe,:email_responsable_sepe,:anotaciones, :responsable_id,:coordinador_id)
  end

end
