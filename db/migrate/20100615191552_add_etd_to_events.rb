class AddEtdToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :etd, :boolean, :default => 0
  end

  def self.down
    remove_column :events, :etd
  end
end
