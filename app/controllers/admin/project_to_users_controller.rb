class Admin::ProjectToUsersController < Admin::AdminController
  permit Role::ADMIN

  def index
    add_crumb :label => t("crumbs.team")
    @users = User.not_in_project(@project.id)
    @roles = Role.project_roles
  end

  def grid_data
    data = []

    user_roles = {}
    RolesUser.project_roles(@project.id).each do |ur|
      user_roles[[ur.user_id, ur.role.name]] = true
    end

    User.by_project(@project.id).each do |user|
      cells = [user.full_name, user.hours]
      Role.project_roles.each do |role|
        cells << (user_roles.has_key?([user.id, role]) ? "Yes" : "No")
      end
      data << {:id => user.id, :cell => cells}
    end

    render :json => { :rows => data, :page => 1, :total => 1, :records => data.size}.to_json
  end

  def grid_edit
    # TODO: throw exception if params[:oper] != "del"
    User.find(params[:id].split(",")).each { |user| ProjectToUser.unassign(@project, user) }
    render :json => {:success => true, :message => t("messages.project_to_users_deleted")}.to_json
  end

  def set_role
    user = User.find(params[:user_id])
    role = params[:role]
    if params[:has_access] == true.to_s
      @project.accepts_role role, user
      message_template = t("messages.role_assigned")
    else
      @project.accepts_no_role role, user
      message_template = t("messages.role_unassigned")
    end
    message = apply_params(message_template, {:user => user.full_name, :role => role, :project => @project.name})
    render :json => { :success => true, :message => message}.to_json
  end

  def create
    @user = User.find(params[:user_id])
    @project_to_user = ProjectToUser.new
    @project_to_user.user = @user
    @project_to_user.project = @project
    if @project_to_user.save
      success t("messages.user_assigned")
      redirect_to admin_project_users_path
    else
      error t("messages.some_errors")
      render :action => 'index'
    end
  end

  before_filter :init_project

  def init_project
    @project = Project.find(params[:project_id])
    add_crumb :label => t("crumbs.projects"), :link => admin_projects_path
    add_crumb :label => @project.name, :link => admin_project_path(:id => @project.id)
    add_crumb :label => t("crumbs.edit"), :link => edit_admin_project_path(:id => @project.id)
  end

  def apply_params(template, params)
    template.gsub(/\{\{(\w+)\}\}/) {|s| params[$1.to_sym]}
  end
end

