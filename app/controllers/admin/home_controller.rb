class Admin::HomeController < Admin::AdminController
  permit Role::ADMIN
  
  def dashboard
  end
end
