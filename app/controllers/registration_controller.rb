class RegistrationController < ApplicationController
  permit "not (#{Role::FRONT_USER} or #{Role::ADMIN})", :allow_guests => true
  
  def register
    @user = User.new
  end

  def save
    @user = User.new(params[:user])
    if @user.save
      @user.has_role Role::FRONT_USER
      success "Welcome to agile tool!"
      redirect_to :controller => :home, :action => :dashboard
    else
      render :action => :register
    end
  end
end
