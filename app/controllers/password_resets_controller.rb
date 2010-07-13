class PasswordResetsController < ApplicationController
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  
  def new
  end  

  def create  
    @user = User.find_by_email(params[:email])  
    if @user  
      @user.deliver_password_reset_instructions!  
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +  
      "Please check your email."  
      redirect_to root_url  
    else  
      flash[:notice] = "No user was found with that email address"  
      render :action => :new  
    end  
  end
  
  def edit  
  end  

  def update  
    # if params[:user][:openid_identifier]
    #   puts "identifier: #{params[:user][:openid_identifier]}"
    #   @user.update_attribute(params[:user])
    # else

    @user.password = params[:user][:password]  
    @user.password_confirmation = params[:user][:password_confirmation]  
    # end
    
    if @user.save  
      flash[:notice] = "Password successfully updated"  
      redirect_to root_url  
    else  
      render :action => :edit  
    end  
  end  

  private  
  def load_user_using_perishable_token  
    @user = User.find_using_perishable_token(params[:id])  
    unless @user  
      flash[:notice] = "We're sorry, but we could not locate your account. " +  
        "If you are having issues try copying and pasting the URL " +  
        "from your email into your browser or restarting the " +  
        "reset password process."  
      redirect_to root_url  
    end
  end  
  
  def require_no_user
    unless current_user.nil?
      flash[:notice] = "You are already logged in #{current_user.username}. If you wish to reset your password simply " + 
        "click the edit Profile link at the top of the page."
      redirect_to instruments_path   
    end
  end
  
end
