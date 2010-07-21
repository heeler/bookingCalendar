class Admin::UsersController < ApplicationController    
  before_filter :authorized_admin
   
  def index    
    @authorized_users = User.all(:conditions => ["authorized = ? OR walkup = ?", true, true])
    @unauthorized_users = User.all(:conditions => {:authorized => false, :walkup => false})
  end   
   
  def update
    user_to_notify = User.update( params[:id], :authorized => false, :walkup => false )  
    Notifier.delay.deliver_account_suspended(user_to_notify, current_user)
    redirect_to admin_users_path
  end
   
   
  def authorize   
    auth_users = []
    walk_users = []
    if params[:authorize_user_ids]
      User.update_all(["authorized=?", true], :id => params[:authorize_user_ids]) 
      auth_users = User.find(params[:authorize_user_ids])
    end
    if params[:walkup_user_ids]    
      User.update_all(["walkup=?", true], :id => params[:walkup_user_ids]) 
      walk_users = User.find(params[:walkup_user_ids])
    end
    users_to_notify = [auth_users, walk_users]
    users_to_notify.flatten!.compact!
    users_to_notify.each {|u| Notifier.delay.deliver_account_authorized(u)}

    redirect_to admin_users_path
  end                     

  def test_email
    @user = User.find(params[:id])
    Notifier.delay.deliver_mytest(@user)
#    Notifier.delay.deliver_account_suspended(@user, current_user)
    redirect_to admin_users_path
  end

end
