class AddWalkupToUser < ActiveRecord::Migration
  def self.up
    
    create_table :tusers do |t|
      t.string :username  
      t.string :fullname
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :openid_identifier, :default => ""
      t.boolean :admin, :default => 0
      t.boolean :authorized, :default => 0
      t.boolean :walkup, :default => 0
      t.string :color, :default => "CC33FF"
      t.timestamps
    end
    
    say_with_time "Moving existing users to tusers" do      
      users = User.all
      users.each do |usr|
        tusr = Tuser.new
        tusr.id = usr.id
        tusr.username = usr.username
        tusr.fullname = usr.fullname
        tusr.email = usr.email
        tusr.crypted_password = usr.crypted_password
        tusr.password_salt = usr.password_salt
        tusr.openid_identifier = usr.openid_identifier
        tusr.admin = usr.admin
        tusr.authorized = usr.authorized
        tusr.walkup = false
        tusr.color = usr.color
        tusr.created_at = usr.created_at
        tusr.updated_at = usr.updated_at
        tusr.save(false)
      end
    end
    
    drop_table :users
    
    create_table :users do |t|
      t.string :username  
      t.string :fullname
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :openid_identifier, :default => ""
      t.boolean :admin, :default => 0
      t.boolean :authorized, :default => 0
      t.boolean :walkup, :default => 0
      t.string :color, :default => "CC33FF"
      t.timestamps
    end
    
    User.reset_column_information
    
    say_with_time "Moving existing tusers to users" do      
      users = Tuser.all
      users.each do |usr|
        tusr = User.new
        tusr.id = usr.id
        tusr.username = usr.username
        tusr.fullname = usr.fullname
        tusr.email = usr.email
        tusr.crypted_password = usr.crypted_password
        tusr.password_salt = usr.password_salt
        tusr.openid_identifier = usr.openid_identifier
        tusr.admin = usr.admin
        tusr.authorized = usr.authorized
        tusr.walkup = false
        tusr.color = usr.color
        tusr.created_at = usr.created_at
        tusr.updated_at = usr.updated_at
        tusr.save(false)
      end
    end
    
    drop_table :tusers
      
  end

  def self.down
  end
end
