# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  helper :all # include all helpers, all the time
  helper_method :available_locales, :current_user_session, :current_user, :error, :success, :add_root_crumb, :add_crumb

  protect_from_forgery :except => [:grid_edit]

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter :set_locale

  protected
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  private
  
  def available_locales
    I18n.available_locales
  end 

  # Sets current locale by request url.
  def set_locale
    current_locale = params[:locale]
    I18n.locale = current_locale if current_locale && I18n.available_locales.include?(current_locale.to_sym)
  end

  # Sets default url routing values hash.
  def default_url_options(options={})
    options[:locale] = I18n.locale
    options
  end

  # Adds error message to flash hash.
  def error(message, name=:notice_error)
    flash[name] = {:message => message}
  end

  # Adds success message to flash hash.
  def success(message, name=:notice_success)
    flash[name] = {:message => message, :success => true}
  end
    
  def add_root_crumb(crumb={})
    defaults = {:link => home_path, :label => t("crumbs.home"), :class => "first"}
    @crumbs = [defaults.merge(crumb)]
  end
  
  def add_crumb(crumb)
    add_root_crumb unless @crumbs
    @crumbs << crumb
  end
  
  def parse_grid_data(total)
    @page = 0
    @page = params[:page].to_i if params[:page]

    @pageSize = 0
    @pageSize = params[:rows].to_i if params[:rows]

    @order = ""
    @order = "#{params[:sidx]} #{params[:sord]}" if params[:sidx] && params[:sord]

    @total = total

    @totalPages = @total / @pageSize
    @totalPages += 1 if @total % @pageSize > 0
  end
end