class Admin::UsersController < Admin::AdminController
  permit Role::ADMIN

  def index
    add_crumb :label => t("crumbs.users")
  end

  def grid_data
    users = User.find(:all) do
      if params[:_search] == "true"
        first_name =~ "%#{params[:first_name]}%" if params[:first_name].present?
        last_name  =~ "%#{params[:last_name]}%" if params[:last_name].present?
        email     =~ "%#{params[:email]}%" if params[:email].present?
      end
      paginate :page => params[:page], :per_page => params[:rows]
      order_by "#{params[:sidx]} #{params[:sord]}"
    end

    respond_to do |format|
      format.html
      format.json { render :json => users.to_jqgrid_json([:first_name,:last_name,:email],
                                                         params[:page], params[:rows], users.total_entries) }
    end
  end

  def grid_edit
    if params[:oper] == "del"
      User.find(params[:id].split(",")).each { |user| user.destroy }
    else
      user_params = {
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :email => params[:email]
      }

      User.find(params[:id]).update_attributes(user_params)
    end
    render :json => {:success => true, :message => t("messages.users_deleted")}.to_json
  end

  def show
    @user = User.find(params[:id])
    add_crumb :label => t("crumbs.users"), :link => admin_users_path
    add_crumb :label => @user.full_name
  end

  def new
    @user = User.new
    add_crumb :label => t("crumbs.users"), :link => admin_users_path
    add_crumb :label => t("crumbs.new")
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      @user.has_role Role::FRONT_USER
      success t("messages.user_created")
      redirect_to admin_user_url(:id => @user.id)
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
    add_crumb :label => t("crumbs.users"), :link => admin_users_path
    add_crumb :label => @user.full_name, :link => admin_user_path(@user)
    add_crumb :label => t("crumbs.edit")
  end

  def update
    @user = User.find(params[:id])

    add_crumb :label => t("crumbs.users"), :link => admin_users_path
    add_crumb :label => @user.full_name, :link => admin_user_path(@user)
    add_crumb :label => t("crumbs.edit")

    if @user.update_attributes(params[:user])
      success t("messages.user_updated")
      redirect_to [:admin, @user]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    success t("messages.user_deleted")
    redirect_to admin_users_url
  end

  def destroy_multiple
    User.find(params[:id]).each do |user|
      user.destroy
    end
    respond_to do |format|
      format.json { render :json => {:message => t("messages.users_deleted")}}
    end
  end
end

