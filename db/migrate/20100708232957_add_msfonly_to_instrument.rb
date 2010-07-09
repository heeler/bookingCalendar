class AddMsfonlyToInstrument < ActiveRecord::Migration
  def self.up
    add_column :instruments, :msf_only, :boolean, :default => 1

    Instrument.reset_column_information
    say_with_time "Adding msf_only to existing instruments" do      
      insts = Instrument.all
      insts.each do |inst|
        inst.msf_only = true
        inst.save
      end
    end
      
  end

  def self.down
    remove_column :instruments, :msf_only
  end
end
