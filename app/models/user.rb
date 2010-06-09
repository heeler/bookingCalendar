class User < ActiveRecord::Base
  before_create :set_defaults
  
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
  
  def set_defaults
    self.openid_identifier = ""
    self.authorized = false
    self.admin = false 
    self.quota_multiplier = 1
    self.color = "CC33FF"
  end
  
  
  def map_openid_registration(registration)
    puts registration
    self.email = registration["email"] if email.blank?
    self.username = registration["nickname"] if username.blank?
    self.username = registration["fullname"] if username.blank?    
  end
end
