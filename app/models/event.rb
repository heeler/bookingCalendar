class Event < ActiveRecord::Base
  has_event_calendar

  belongs_to :user
  belongs_to :instrument
  named_scope :between, lambda {|hash| { :conditions => ['start_at between ? and ?', hash[:start], hash[:end] ] } }
  named_scope :current_user_events, lambda { |hash| { :conditions => ['(start_at between ? and ? OR end_at between ? and ?) and user_id == ?',
                                              hash[:date], hash[:date] + 7, hash[:date], hash[:date] + 7, hash[:user_id]] } }  
  named_scope :starting_after, lambda { |date| { :conditions => ['start_at >= ?', date] }}        
  validates_presence_of :user_id, :instrument_id, :project_pi
  validates_numericality_of :project, :only_integer => true
  validates_acceptance_of :al_approved, :accept => true, :message => 'ALL PROJECTS ESPECIALLY 318 REQIRE AUTHORIZATION BY AL BURLINGAME'
  validate :not_already_booked 
  validate :orbitrap_rules_satisfied
  #validate :orbi_quota_ok
  
  def assign_duration(event)
    mtime = Time.local(event["start_at(1i)"].to_i, event["start_at(2i)"].to_i, 
                                 event["start_at(3i)"].to_i,
                                 event["start_at(4i)"].to_i, 
                                 event["start_at(5i)"].to_i ) 

    self.start_at = mtime
    self.end_at = mtime + event[:duration].to_i.hours
  end
  
  def duration=(d)
    return if self.start_at.nil?
    self.end_at = self.start_at + d.to_i.hours
  end
  
  def duration
    return 0 if self.start_at.nil? | self.end_at.nil?
    self.end_at - self.start_at
  end
  
  def name
    self.user.username + "  #{self.start_at.hour} -> #{self.end_at.hour}"
  end
  
  def title
    parta = self.start_at.strftime("#{self.user.fullname}: %a at ~%H:%M")
    partb = ""
    if self.start_at.day == self.end_at.day
      partb = self.end_at.strftime(" to ~%H:%M")
    else
      partb = self.end_at.strftime(" to %a at ~%H:%M")
    end
    parta + partb
  end
  

  def orbitrap_rules_satisfied
    return true unless self.instrument.orbitrap
    
    case Orbibook.classify_time(self.start_at)
    when Orbibook::WEEKDAY
      if ( self.duration > 2.hours || self.end_at.hour > 16 )
        errors.add_to_base("Weekday bookings are limited to 2 hours and must finish by 4pm (16:00) on the Orbitrap.")
        return false
      end
      return true
    when Orbibook::WEEKNIGHT
      if self.twoweekbooking == true && self.duration > 24.hours
        errors.add_to_base("Extended weeknight booking are not permited to be longer than 24 hours.")
        return false
      elsif self.twoweekbooking == false 
        if self.duration > 16.hours
          errors.add_to_base("Standard weeknight booking are not permited to be longer than 16 hours.")
          return false
        elsif self.end_at.hour > 8
          errors.add_to_base("Standard weeknight booking must conclude by 8am. To circumvent this you must elect a 2 week booking.")
          return false
        end
      end
      return true 
    when Orbibook::WEEKENDFRI
      if self.duration > 20.hours
        errors.add_to_base("Friday night bookings must end by 12:00 Saturday. 
                            Once started though you can extend the booking, if the instrument is free.")
        return false
      end
      return true
    when Orbibook::WEEKENDSAT
      if self.duration > 22.hours
        errors.add_to_base("Saturday bookings must end by 12:00 Sunday. 
                            Once started though you can extend the booking, if the instrument is free.")
        return false
      end
      return true
    when Orbibook::WEEKENDSUN
      if self.twoweekbooking == false && self.duration > 22.hours
        errors.add_to_base("Sunday bookings must end by 8:00 Monday. 
                            Once started though you can extend the booking, if the instrument is free.")
        return false
      elsif self.twoweekbooking == true && self.duration > 30.hours
        errors.add_to_base("Sunday->Monday extended bookings must end by 4pm (16:00) Monday.")
        return false
      end
      return true
    when Orbibook::WEEKENDLastMinute
      return true
    end
    
  end

  def orbi_quota_ok
    return true unless self.instrument.orbitrap
    return true if self.user.quota_multiplier == 0
    return true if Orbibook.classify_time(self.start_at) == Orbibook::WEEKENDLastMinute
    
    date = self.start_at.at_midnight + 8.hours #monday at 8am new week starts so set time to 8
    date -= 1.days until date.to_date.cwday == 1 # compute monday of the week of the booking
    previousMon = date - 1.week
    nextMon = date + 1.week

    # have they already booked time this week? if so no dice
    current = Event.between({:start => date, :end => nextMon})
    current.each do |event| 
      if Orbibook.classify_time(event.start_at) != Orbibook::WEEKDAY 
        errors.add_to_base("You have already made \"16 hour\" booking this week. Only one per user.")
        return false 
      end
    end

    # did they make a twoweek booking in the last 2 weeks
    previous_and_current = Event.between({:start => previousMon, :end => nextMon})
    previous_and_current.each do |event| return false 
      if event.twoweekbooking 
        errors.add_to_base("You made an extended booking in the previous 2 weeks. You have used your alotted Orbi time.")
        return false
      end
    end
  end

  def within_quota
    return true if self.user.quota_multiplier == 0
    date = self.start_at.at_midnight
    date -= 1.days until date.to_date.cwday == 1 # compute monday of the week of the booking
    current_events = Event.current_user_events({:date => date.to_date, :user_id => self.user_id})
    summed_time = 0
    puts "START_AT OK!!!!!!" if !self.start_at.nil?
    puts "END_AT OK!!!!!!" if !self.end_at.nil?
    puts current_events.length
    current_events.each do |event|
      puts "ONE !!!!"
      puts "#{event.start_at.class} >> #{event.start_at}"
      puts "#{date.class} >> #{date}"
      if datetime_less_than(event.start_at, date)
        puts "TWO!!!!!"
        summed_time += event.end_at - date # just the portion of time of the booking during the week
      elsif datetime_less_than(date+7.days, event.end_at)
        puts "THREE!!!!!"        
        summed_time += (date+7.days) - event.start_at
      else
        puts "four!!!!!"                
        summed_time += event.duration
      end
    end
    puts "!!!!1:  #{summed_time.hours}"
    summed_time += self.duration
    puts "!!!!2:  #{summed_time.hours}"
    qtime = self.instrument.quota(self.user.quota_multiplier)
    ans = ( summed_time <= qtime.hours )
    errors.add_to_base("This booking would excede your quota of #{qtime} 
    hours per week on this instrument for the week starting #{date.strftime("%a %b %d")}.
    If you wish to make this booking you will have to talk to Dave.") if !ans
    ans  
  end

  def extend_booking(time_s)
    time = time_s.to_i
    all_events = Event.find_all_by_instrument_id(self.instrument_id)
    events_after = all_events.find_all do |e| 
      #puts "starts: #{self.start_at} -- #{e.start_at} :  #{datetime_less_than(self.start_at, e.start_at)}" 
      datetime_less_than(self.start_at, e.start_at )
    end
    events_after.sort! {|a,b| a.start_at <=> b.start_at }
    events_after.each {|e| puts e.start_at }
    changed = []
    unless events_after.empty?
      ntime = time.to_f.hours - (events_after[0].start_at - self.end_at) 
      extend(ntime, events_after, changed)
    end
    self.end_at += time.to_f.hours
    self.save(false)
    puts "self.end_at > #{self.end_at} \t #{time}"
    changed
  end 
  
  def extend(timeshift, events_after, changed_events)
    puts "timeshift: #{timeshift}"
    return if timeshift < 0
    event = events_after.shift
    changed_events << event
    unless events_after.empty?
      deltatime = events_after[0].start_at - event.end_at
      extend(timeshift - deltatime ,events_after, changed_events)
    end
    event.start_at += timeshift # no .hours here or it multiplies them by 60 again screwing up the calc
    event.end_at += timeshift
    event.save(false)
  end

  def overlap?( event )
    dstart = self.start_at.to_datetime.in_time_zone
    dend = self.end_at.to_datetime.in_time_zone
    return false if datetime_less_than( dend, event.start_at.in_time_zone )
    return false if datetime_less_than( event.end_at.in_time_zone, dstart)
    true
  end

  def in_progress?
    time_now = DateTime.now.in_time_zone
    dstart = self.start_at.to_datetime.in_time_zone
    dend = self.end_at.to_datetime.in_time_zone
    #puts "[#{dstart} < #{time_now} < #{dend}]"
    return false if datetime_less_than( dend, time_now.in_time_zone )
    return false if datetime_less_than( time_now.in_time_zone, dstart)
    true
  end
  
  def datetime_less_than(a,b)
     # is a < b
     ((b <=> a) > 0)
  end
  
  def color
    color = self.user.color
    color = "009999" if color.nil?
    #color = rand(0xffffff).to_s(16) #if color.nil? || color.empty?
    return "\##{color}"
  end
  # 
  # def colorrgb
  #   colorarr = [46, 172, 106]
  #   colorarr = self.user.color.scan(/../).map {|color| color.to_i(16)} unless self.user.color.nil?
  #   "rgb( #{colorarr.join(', ') }"
  # end
  
  def not_already_booked
    events = Event.find_all_by_instrument_id(self.instrument_id)
    conflict = nil
    ans = events.inject(false) do |res, val| # res = res || val.overlap?(self);   }
      conflict = val if val.overlap?(self)
      res | val.overlap?(self);  
    end

    if ans
      estr = "Scheduling conflict: Prior conflicting Booking.\n\t #{conflict.user.username}: #{conflict.start_at} -> #{conflict.end_at}"
      errors.add_to_base(estr)
    end
    (!ans)
  end
  
  
  
end