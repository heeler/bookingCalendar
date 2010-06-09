module EventsHelper
  
  def dayPull(day)
    vals = {}
    0.upto(13) do |i|
      d = day + i.days
      vals[d.strftime("%b %d")] = d
    end
    vals
  end
  
  
  def possible_duration
    ans = 1.upto(24).inject({}) {|res, i| res[(i*2).to_s + " hours"] = i*2; res }
  end
  
  def possible_extention
    ans = 1.upto(4).inject({}) {|res, i| res[(i).to_s + " hours"] = i; res }
    ans = 1.upto(24).inject({}) {|res, i| res[(i*2).to_s + " hours"] = i*2; res } if admin?
    ans
  end
      
  def pending(event)
    (event.approved) ? "approved" : "pending"
  end    
  
  def not_already_checked(event)
    return true if event.nil?
    return true if event.al_approved.nil?
    (event.al_approved != true) 
  end                                
  
  def possible_blocks
    time = Time.now.at_midnight
    res = {}
    0.upto(13) do |day|
      dt = time + day.days
      case dt.to_date.cwday
      when 1..4
        res[(dt + 16.hours).strftime("%a %b, %d at %I %P")] = (dt + 16.hours)
        res[(dt + 24.hours).strftime("%a %b, %d at %I %P")] = (dt + 24.hours)                
      when 5
        res[(dt + 16.hours).strftime("%a %b, %d at %I %P")] = (dt + 16.hours)
        res[(dt + 26.hours).strftime("%a %b, %d at %I %P")] = (dt + 26.hours)        
      when 6
        res[(dt + 12.hours).strftime("%a %b, %d at %I %P overnight till 10am")] = (dt + 12.hours)
        res[(dt + 23.hours).strftime("%a %b, %d at %I %P overnight till 10am")] = (dt + 23.hours)
      when 7
        res[(dt + 10.hours).strftime("%a %b, %d at %I %P overnight till 8am")] = (dt + 10.hours)
        res[(dt + 21.hours).strftime("%a %b, %d at %I %P overnight till 8am")] = (dt + 21.hours)        
      end
    end
    res
  end
  
  def default_time
    time = possible_blocks.shift
    @dt = time[1]
  end
  
  
  def orbi_duration(dt)
    if dt.nil?
      dt = possible_blocks.shift
      dt = dt[-1]
    end
    ans = {}
    case dt.to_date.cwday
    when 1..5
      ans["16 hours"] = 16 if dt.hour == 16
      ans["8 hours"] = 8
    when 6
      if dt.hour == 2
        ans["10 hours"] = 10
      else
        ans["20 hours"] = 20 if dt.hour == 12
        ans["10 hours"] = 10
      end
    when 7
      ans["20 hours"] = 20 if dt.hour == 10
      ans["10 hours"] = 10
    end
    ans
  end
  
end
