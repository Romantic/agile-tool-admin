class HomeController < ApplicationController
  def dashboard
    unless current_user
      redirect_to login_path
    else
      if current_user.is_admin?
          redirect_to admin_home_url
      end
    end
  end
  
  def login
    if current_user
      if current_user.is_admin?
        redirect_to admin_home_url
      else
        redirect_to home_url
      end
    else
      @user_session = UserSession.new
    end
  end

  def create_user_session
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      success t("messages.login_success")
      if @user_session.record.is_admin?
        redirect_to admin_home_url
      else
        redirect_to home_url
      end
    else
      render :action => :login
    end
  end
  
  def logout
    @user_session = UserSession.find
    @user_session.destroy
    success t("messages.logout_success")
    redirect_to login_url
  end
end
