# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  
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
  
  def authorized_users_only
    redirect_to root_url if current_user.nil? || !current_user.authorized
  end
  
  def msf_or_walkup_user
    return false if current_user.nil?
    return current_user.authorized || current_user.walkup
  end
  
  def authorized_admin  
    redirect_to instrument_path unless admin?
  end     
  
  def logged_in
     redirect_to login_path if current_user.nil?
  end                                           
  
  
end
