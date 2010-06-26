class UserSessionsController < ApplicationController
  def new
    @openid, @myrender = parse_loginmethod(params[:loginmethod])    
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        flash[:notice] = "Successfully logged in."
        redirect_to root_url
      else
        @openid, @myrender = parse_loginmethod(params[:loginmethod])
        render :action => 'new'
      end
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end
  
  def loginmethod
    @user_session = UserSession.new
    @openid, @myrender = parse_loginmethod(params[:loginmethod])
    render :partial => "loginmethod"
  end
  
  private
  
  def parse_loginmethod(val)   
    mopen_id = false
    myrender = true
    unless val.nil?
      case val
        when '1'  
          mopen_id = false
        when '2' 
          mopen_id = true
      end
    end
    return mopen_id, myrender
  end
  
end
