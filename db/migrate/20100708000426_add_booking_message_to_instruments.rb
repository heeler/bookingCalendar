class AddBookingMessageToInstruments < ActiveRecord::Migration
  def self.up
    add_column :instruments, :msf_only, :boolean, :default => 1
    add_column :instruments, :booking_message, :text, :default => ""
    add_column :instruments, :rules, :text, :default => ""    
  end

  def self.down
    remove_column :instruments, :rules
    remove_column :instruments, :booking_message
    remove_column :instruments, :msf_only
  end
end

