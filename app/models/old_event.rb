class Event < ActiveRecord::Base
  belongs_to :user
  belongs_to :instrument
  named_scope :week_starting, lambda { |date| { :conditions => ['starts_at between ? and ?', date, date + 7] } }
  named_scope :starting_after, lambda {|date| { :conditions => ['starts_at between ? and ?', date, date +356] } }
#  named_scope :starting_after, lambda {|date| { :conditions => {:starts_at > date-1 } } }  
  validates_presence_of :user_id, :instrument_id
  validate :not_already_booked
  
  
  def start_day
    self.starts_at
  end
  
  # def start_day=(day)
  #   self.starts_at = day.at_midnight
  # end
  
  # def start_hour
  #   return 12.hours if self.starts_at.nil?
  #   (self.starts_at - self.starts_at.to_datetime.at_midnight)/3600
  # end
  
  # def start_hour=(time)
  #   self.starts_at = self.starts_at + time.to_f.hours
  # end
  
  
  def ends_at
    self.starts_at + duration.hours
  end
  
  
  def not_already_booked
    events = Event.find_all_by_instrument_id(self.instrument_id)
    conflict = nil
    ans = events.inject(false) do |res, val| # res = res || val.overlap?(self);   }
      conflict = val if val.overlap?(self)
      res | val.overlap?(self);  
    end

    if ans
      estr = "Scheduling conflict: Prior conflicting Booking.\n\t #{conflict.user.username}: #{conflict.starts_at} -> #{conflict.ends_at}"
      errors.add_to_base(estr)
    end
    (!ans)
  end

  def extend_booking(time)
    all_events = Event.find_all_by_instrument_id(self.instrument_id)
    puts "all_events.length: #{all_events.length}"
    events_after = all_events.find_all do |e| 
      puts "starts: #{self.starts_at} -- #{e.starts_at} :  #{datetime_less_than(self.starts_at, e.starts_at)}" 
      datetime_less_than(self.starts_at, e.starts_at )
    end
    puts "events_after.length: #{events_after.length}"
    events_after.sort! {|a,b| a.starts_at <=> b.starts_at }
    events_after.each {|e| puts e.starts_at }
    puts "time: #{time}"
    ntime = time.to_f.hours - (events_after[0].starts_at - self.ends_at) 
    puts "ntime: #{ntime}"
    extend(ntime, events_after) unless events_after.empty?
    self.ends_at += time.to_f.hours
    self.save(false)
    puts "self.ends_at > #{self.ends_at} \t #{time}"
  end 
  
  def extend(timeshift, events_after)
    puts "timeshift: #{timeshift}"
    return if timeshift < 0
    event = events_after.shift
    unless events_after.empty?
      deltatime = events_after[0].starts_at - event.ends_at
      extend(timeshift - deltatime ,events_after)
    end
    event.starts_at += timeshift # no .hours here or it multiplies them by 60 again screwing up the calc
    event.ends_at += timeshift
    event.save(false)
    puts "event.ends_at > #{event.ends_at} \t #{timeshift}"
  end

  def overlap?( event )
    dstart = self.starts_at.to_datetime.in_time_zone
    dend = self.ends_at.to_datetime.in_time_zone
    return false if datetime_less_than( dend, event.starts_at.in_time_zone )
    return false if datetime_less_than( event.ends_at.in_time_zone, dstart)
    puts "OVERLAP"
    true
  end

  def in_progress?
    time_now = DateTime.now.in_time_zone
    dstart = self.starts_at.to_datetime.in_time_zone
    dend = self.ends_at.to_datetime.in_time_zone
    #puts "[#{dstart} < #{time_now} < #{dend}]"
    return false if datetime_less_than( dend, time_now.in_time_zone )
    return false if datetime_less_than( time_now.in_time_zone, dstart)
    true
  end
  

  def datetime_less_than(a,b)
     # is a < b
     ((b <=> a) > 0)
  end
  
end


