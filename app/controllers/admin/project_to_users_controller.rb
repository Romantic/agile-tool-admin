class Admin::ProjectToUsersController < Admin::AdminController
  permit Role::ADMIN

  def index
    add_crumb :label => t("crumbs.team")
    @users = User.not_in_project(@project.id)

    @user_roles = {}
    RolesUser.project_roles(@project.id).each do |ur|
      @user_roles[[ur.user_id, ur.role.name]] = true
    end
    @data = []
    User.by_project(@project.id).each do |user|
      row = [user.full_name, user.hours]
      Role::OBJECT_ROLES.each do |role|
        row << @user_roles.has_key?([user.id, role])
      end
      @data << row
    end
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

  def update
  end

  def destroy
  end

  before_filter :init_project

  def init_project
    @project = Project.find(params[:project_id])
    add_crumb :label => t("crumbs.projects"), :link => admin_projects_path
    add_crumb :label => @project.name, :link => admin_project_path(:id => @project.id)
    add_crumb :label => t("crumbs.edit"), :link => edit_admin_project_path(:id => @project.id)
  end
end

