class User < ActiveRecord::Base
  
  has_many :messages
  has_many :events
  has_many :instruments, :through => :events
  
  acts_as_authentic do |c|
    c.openid_required_fields = [:nickname, :email, :fullname]
  end
  #attr_accessible :username, :email, :password
  
  def admin?
    admin
  end
  
  private 
  
  def map_openid_registration(registration)
    self.email = registration["email"] if email.blank?
    self.username = registration["nickname"] if username.blank?
    self.username = registration["fullname"] if username.blank?    
    self.fullname = registration["fullname"] if fullname.blank?
  end
end
