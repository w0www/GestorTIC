class DepartmentsController < ApplicationController
  unloadable

  include Redmine::SafeAttributes

  helper :members
  helper :attachments

  def index
    limit = per_page_option
    @departments_count = Department.count
    @departments_pages = Paginator.new(@departments_count, limit, params['page'])
    @departments = Department.all
    respond_to do |format|
      format.html { render :template => 'departments/index.html.erb', :layout => !request.xhr? }
    end
  end

  def show
    @department = Department.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def new
    @members = User.active.where("type <> 'AnonymousUser'")
    @department = Department.new
    respond_to do |format|
      format.html 
      format.js do
        render :update do |page|
          page.replace_html "departments", :partial => 'issues/departments', :locals => { :issue => @issue, :project => @project }
        end
      end
    end
  end

  def edit
    @department = Department.find(params[:id])
    @members = User.active.where("type <> 'AnonymousUser'")
    respond_to do |format|
      format.html
    end
  end

  def update
    @department = Department.find(params[:id])
    respond_to do |format|
      @department.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))  
      @department.attach_saved_attachments 
      if @department.update_attributes(departments_params)
        flash[:notice] = 'Department updated!'
        format.html { redirect_to @department }
      else
        format.html { render :edit }
      end
    end
  end
  
  def addissue
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
    @department = Department.find(params[:department][:department_id])
    @department.issues << @issue
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def removeissue
    @issue = Issue.find(params[:issue_id])
    @project = @issue.project
    @department = Department.find(params[:department_id])
    @source = params[:source]
    @department.issues.delete(@issue)
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def adduser
    @department = Department.find(params[:department_id])
    @usuarios_ids = []
    @members = []
    if params[:member] && params[:member] != "" && request.post?
      for u in params[:member]
        @usuarios_ids << u.last
        @members << User.find(u.last)
      end
      @department.users << @members
    end
    respond_to do |format|
      format.html { redirect_to :controller => 'departments', :action => 'edit', :id => @department }
      format.js
    end
  end
  
  def removeuser
    @department = Department.find(params[:department_id])
    @department.users.delete(User.find(params[:user_id]))
    respond_to do |format|
      format.html { redirect_to :controller => 'departments', :action => 'edit', :id => @department }
      format.js
    end
  end

  def removeattachment
    @department = Department.find(params[:id])
    @department.attachments.delete(Attachment.find(params[:attachment_id]))
    respond_to do |format|
      format.html { redirect_to :controller => 'departments', :action => 'show', :id => @department }
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
    @department = Department.new(departments_params)
    @department.save_attachments(params[:attachments] || (params[:issue] && params[:issue][:uploads]))  
    @department.attach_saved_attachments  
    respond_to do |format|
      if @department.save
        format.html { redirect_to edit_department_path :id => @department }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @department = Department.find(params[:id])
    respond_to do |format|
      if @department.destroy
        flash[:notice] = "Department removed!"
        format.html { redirect_to :controller => 'departments', :action => 'index', :per_page => params[:per_page], :page => params[:page] }
        format.js { render(:update) { |page| page.replace_html "departments", :partial => 'departments/list', :locals => {:departments => @departments } } }
      else
        flash[:error] = "Couldn't delete department"
        format.html { redirect_to :controller => 'departments', :action => 'index' }
        format.js { render(:update) { |page| page.replace_html "departments", :partial => 'departments/list', :locals => {:departments => @departments } } }          
      end
    end
  end

  def autocomplete_for_user
    @department = Department.find(params[:department_id])
    @users = User.active.like(params[:q]).all(:limit => 100) - @department.users
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
  def departments_params
    params.require(:department).permit(:nombre, :codigo,:direccion,:direccion2,:codigo_postal,:localidad,:territorio,:telefono,:fax,:email_oficina,:telefono_vigilante,
                                        :responsable_sepe,:telefono_responsable_sepe,:email_responsable_sepe,:anotaciones, :responsable_id,:coordinador_id)
  end

end
