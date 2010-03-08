class Admin::AdminController < ApplicationController
  layout "admin" 
   
  protected
  
  def add_root_crumb(crumb={})
    defaults = {:link => admin_home_path, :label => t("crumbs.home"), :class => "first"}
    @crumbs = [defaults.merge(crumb)]
  end
end