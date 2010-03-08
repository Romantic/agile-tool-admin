class ProfileController < ApplicationController
  permit Role::FRONT_USER
  
  def edit
    @user = current_user
  end

  def save
    @user = current_user
    if @user.update_attributes(params[:user])
      success t("messages.profile_updated")
      redirect_to :controller => :home, :action => :dashboard
    else
      render :action => :edit
    end
  end
end
