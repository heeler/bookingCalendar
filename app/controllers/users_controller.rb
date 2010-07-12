class UsersController < ApplicationController
  
  def index 
    @users = User.all
  end

  def new
    @user = User.new
    @user.color = RailsExtensions::Colors.hsv_to_hex(rand(0), 0.8, 0.6)[1..7]
  end
  
  def create
    @user = User.new(params[:user])
    @user.save do |result|
      if result
        flash[:notice] = "Registration successful"
        redirect_to root_url
      else
        render :action => 'new'
      end
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    @user.attributes = params[:user]
    @user.save do |result|
      if result
        flash[:notice] = "Successfully updated profile."
        redirect_to root_url
      else
        render :action => 'edit'
      end
    end
  end
  
  def registrationmethod
    @myrender = true
    case params[:loginmethod]
      when '1'  
        @open_id = false
      when '2' 
        @open_id = true
      when '0' 
        @myrender = false
    end
    @user = User.new
    render :partial => "registrationmethod"
  end
  
  
end
