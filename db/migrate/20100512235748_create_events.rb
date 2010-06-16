class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer  :user_id
      t.integer  :instrument_id
      t.string   :project
      t.string   :project_pi
      t.boolean  :al_approved
      t.boolean  :twoweekbooking, :default => 0
      t.text     :description
      t.datetime :start_at
      t.datetime :end_at
      t.boolean  :approved, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
