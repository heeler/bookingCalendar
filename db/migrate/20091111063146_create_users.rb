class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username  
      t.string :fullname
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.string :openid_identifier
      t.boolean :admin
      t.boolean :authorized
      t.string :color
      t.float :quota_multiplier
      t.timestamps
    end
  end
  
  def self.down
    drop_table :users
  end
end
