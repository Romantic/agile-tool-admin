class Admin::ProjectsController < Admin::AdminController
  permit Role::ADMIN

  def index
    add_crumb :label => t("crumbs.projects")
  end

  def grid_data
    projects = Project.find(:all) do
      if params[:_search] == "true"
        name =~ "%#{params[:name]}%" if params[:name].present?
        name =~ "%#{params[:start_date]}%" if params[:start_date].present?
        name =~ "%#{params[:end_date]}%" if params[:end_date].present?
      end
      paginate :page => params[:page], :per_page => params[:rows]
      order_by "#{params[:sidx]} #{params[:sord]}"
    end

    respond_to do |format|
      format.html
      format.json { render :json => projects.to_jqgrid_json([:name,:start_date,:end_date],
                                                         params[:page], params[:rows], projects.total_entries) }
    end
  end

  def grid_edit
    if params[:oper] == "del"
      Project.find(params[:id].split(",")).each { |project| project.destroy }
    else
      project_params = {
        :name => params[:name],
        :start_date => params[:start_date],
        :end_date => params[:end_date]
      }

      Project.find(params[:id]).update_attributes(project_params)
    end
    render :json => {:success => true, :message => t("messages.projects_deleted")}.to_json
  end

  def show
    @project = Project.find(params[:id])
    add_crumb :label => t("crumbs.projects"), :link => admin_projects_path
    add_crumb :label => @project.name
  end

  def new
    @project = Project.new
    add_crumb :label => t("crumbs.projects"), :link => admin_projects_path
    add_crumb :label => t("crumbs.new")
  end

  def create
    @project = Project.new(params[:project])
    if @project.save
      success t("messages.project_created")
      redirect_to admin_project_url(:id => @project.id)
    else
      render :action => 'new'
    end
  end

  def edit
    @project = Project.find(params[:id])
    add_crumb :label => t("crumbs.projects"), :link => admin_projects_path
    add_crumb :label => @project.name, :link => admin_project_path(@project)
    add_crumb :label => t("crumbs.edit")
  end

  def update
    @project = Project.find(params[:id])

    add_crumb :label => t("crumbs.projects"), :link => admin_projects_path
    add_crumb :label => @project.name, :link => admin_project_path(@project)
    add_crumb :label => t("crumbs.edit")

    if @project.update_attributes(params[:project])
      success t("messages.project_updated")
      redirect_to [:admin, @project]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    success t("messages.project_deleted")
    redirect_to admin_projects_path
  end

  def roles
    @project = Project.find(params[:project_id])
    roles_translate_scope = [:activerecord, :attributes, :role]
    @roles = Role.project_roles
    @roles = @roles.collect {|role| [t(role, :scope => roles_translate_scope), role]}

    @users = User.front_users

    add_crumb :label => t("crumbs.projects"), :link => admin_projects_path
    add_crumb :label => @project.name, :link => admin_project_path(:id => @project.id)
    add_crumb :label => t("crumbs.roles")
  end

  def roles_data
    @project = Project.find(params[:project_id])
    roles_translate_scope = [:activerecord, :attributes, :role]
    @project_roles = []
    @project.roles.each do |role|
        User.by_role_id(role.id).each do |user|
            @project_roles << {
              :user_id => user.id,
              :role => role.name,
              :user_name => user.full_name,
              :role_name => t(role.name, :scope => roles_translate_scope)
            }
        end
    end

    respond_to do |format|
      format.xml { render :partial => 'roles_data.xml.builder', :layout => false }
    end
  end

  def assign_role
    project = Project.find(params[:project_id])
    user = User.find(params[:user_id])
    project.accepts_role params[:role], user
    redirect_to admin_project_roles_path
  end

  def destroy_role
    project = Project.find(params[:project_id])
    user = User.find(params[:user_id])
    project.accepts_no_role params[:role], user
    redirect_to admin_project_roles_path
  end

  before_filter :parse_dates, :only => [:create, :update]

  protected

  def parse_dates
    unless params[:project][:start_date_string].blank?
        params[:project][:start_date] = Date.strptime(params[:project][:start_date_string], t("date.formats.date_picker"))
    end
    params[:project].delete :start_date_string
    unless params[:project][:end_date_string].blank?
        params[:project][:end_date] = Date.strptime(params[:project][:end_date_string], t("date.formats.date_picker"))
    end
    params[:project].delete :end_date_string
  end
end

