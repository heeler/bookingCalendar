# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
#  before_filter :init_time_zone
  
  # def init_time_zone
  #   @time_zone = ActiveSupport::TimeZone[session[:time_zone_name]] if session[:time_zone_name]
  #   Time.zone = @time_zone.name if @time_zone
  # end
  # 
  # def time_zone
  #   offset_seconds = params[:offset_minutes].to_i * 60
  #   @time_zone = ActiveSupport::TimeZone[offset_seconds]
  #   @time_zone = ActiveSupport::TimeZone["Pacific Time (US & Canada)"] unless @time_zone
  #   session[:time_zone_name] = @time_zone.name if @time_zone
  #   render :text => "success"
  # end
  
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  helper_method :current_user, :admin?
  
  private
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end  
          
  def admin?
    return false if current_user.nil?
    current_user.admin? 
  end
  
  def authorized_user
    return false if current_user.nil?
    return current_user.authorized
  end
  
  def authorized_admin  
    redirect_to instruments_path unless admin?
  end     
  
  def logged_in
     redirect_to login_path if current_user.nil?
  end                                           
  
  
end
