module UserSessionsHelper
  
  def login_options
    {"Username/Password" => 1, "OpenID or Google" => 2}
  end
  
  def myselect( val, openid )
    return "Username/Password" if val == false
    return 1 if openid == false 
    return 2 if openid == true
  end

end
