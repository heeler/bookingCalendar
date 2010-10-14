# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def show_title?
    !(@title.nil? || @title.empty?)
  end
  
  
  def logged_in?
    !(current_user.nil?)
  end            
  
  def authorized?
     return false if current_user.nil?
     current_user.authorized
  end
  
  def walkup_ok?
    return false if current_user.nil?
    current_user.walkup
  end
  
  def authorized_to_edit?( user_id )
     return false if !authorized? && !walkup_ok?
     return true if admin?      
     return true if( current_user.id == user_id )
     false
  end
end
