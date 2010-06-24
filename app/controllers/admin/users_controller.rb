class Admin::UsersController < ApplicationController    
  before_filter :authorized_admin
   
  def index    
    @authorized_users = User.all(:conditions => {:authorized => true })
    @unauthorized_users = User.all(:conditions => {:authorized => false})
   end   
   
   def update
      User.update( params[:id], :authorized => false )  
      redirect_to admin_users_path
   end
   
   
   def authorize   
     User.update_all(["authorized=?", true], :id => params[:user_ids])
     @users_to_notify = User.find(params[:user_ids])
     @users_to_notify.each {|u| Notifier.deliver_account_authorized(u)}
     redirect_to admin_users_path
   end             
   

   def suspend
     User.update_all(["authorized=?", false], :id => params[:user_ids])
     #TODO Mark selected as Autharized    
     redirect_to admin_users_path
   end
        

end
