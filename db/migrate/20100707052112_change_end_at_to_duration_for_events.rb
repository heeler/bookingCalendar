class ChangeEndAtToDurationForEvents < ActiveRecord::Migration
  def self.up
    create_table :mytmpevents do |t|
      t.integer  :user_id
      t.integer  :instrument_id
      t.string   :project
      t.string   :project_pi
      t.boolean  :al_approved
      t.boolean  :twoweekbooking, :default => 0
      t.text     :description
      t.boolean  :etd, :default => 0
      t.datetime :start_at
      t.integer  :duration
      t.datetime :end_at
      t.boolean  :approved, :default => 0
      
      t.timestamps
    end
    
    say_with_time "Moveing events to tmpevents" do
      events = Event.all
      events.each do |ev|
        tmp = Mytmpevent.new
        tmp.id = ev.id
        tmp.user_id = ev.user_id
        tmp.instrument_id = ev.instrument_id
        tmp.project = ev.project
        tmp.project_pi = ev.project_pi
        tmp.al_approved = ev.al_approved
        tmp.twoweekbooking = ev.twoweekbooking
        tmp.description = ev.description
        tmp.etd = ev.etd
        tmp.start_at = ev.start_at
        tmp.duration = (ev.end_at - ev.start_at).to_i
        tmp.end_at = ev.end_at
        tmp.created_at = ev.created_at
        tmp.updated_at = ev.updated_at
        tmp.save
      end
    end
    
    drop_table :events
    
    create_table :events do |t|
      t.integer  :user_id
      t.integer  :instrument_id
      t.string   :project
      t.string   :project_pi
      t.boolean  :twoweekbooking, :default => 0
      t.text     :description
      t.boolean  :etd, :default => 0
      t.datetime :start_at
      t.integer  :duration
      t.boolean  :approved, :default => 0
      
      t.timestamps
    end
    
    Event.reset_column_information
    
    say_with_time "Moveing tmpevents to events" do
      events = Mytmpevent.all
      events.each do |ev|
        tmp = Event.new
        tmp.id = ev.id
        tmp.user_id = ev.user_id
        tmp.instrument_id = ev.instrument_id
        tmp.project = ev.project
        tmp.project_pi = ev.project_pi
        tmp.twoweekbooking = ev.twoweekbooking
        tmp.description = ev.description
        tmp.etd = ev.etd
        tmp.start_at = ev.start_at
        tmp.duration = ev.duration
        tmp.created_at = ev.created_at
        tmp.updated_at = ev.updated_at
        tmp.save(false)
      end
    end

    drop_table :mytmpevents
    
  end

  def self.down

  end
end
