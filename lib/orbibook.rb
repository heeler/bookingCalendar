class Orbibook
  def Orbibook.add_item(key,value)
    @hash ||= {}
    @hash[key]=value
  end
  
  def Orbibook.const_missing(key)
    @hash[key]
  end   

  def Orbibook.each
    @hash.each {|key,value| yield(key,value)}
  end

  def Orbibook.classify_time(time)
    #calculate thursday prior to the event
    thurs = time.at_midnight + 16.hours
    thurs -= 1.days until thurs.to_date.cwday == 4
    
    #is the event start time prior to the thursday before today
    withinThurs = ( self.datetime_less_than(time, thurs) ? false : true )

    case time.to_date.cwday
    when 1
      return 5 if time.hour <  8 #weekendsunday
      return 1 if time.hour <  16 #weekday
      return 2 if time.hour >= 16 #weeknight
    when 2..4
      return 1 if time.hour <  16 #weekday
      return 2 if time.hour >= 16 #weeknight
    when 5
      return 1 if time.hour <  16 #weekday
      return (withinThurs ? 6 : 3) if time.hour >= 16 
    when 6
      return (withinThurs ? 6 : 3) if time.hour <  12
      return (withinThurs ? 6 : 4) if time.hour >= 12
    when 7
      return (withinThurs ? 6 : 4) if time.hour <  10
      return (withinThurs ? 6 : 5) if time.hour >= 10
    when 6..7
      return 3 #weekend
    else
      return -1
    end
    return -1
  end


  Orbibook.add_item :WEEKDAY, 1
  Orbibook.add_item :WEEKNIGHT, 2
  Orbibook.add_item :WEEKENDFRI, 3
  Orbibook.add_item :WEEKENDSAT, 4
  Orbibook.add_item :WEEKENDSUN, 5
  Orbibook.add_item :WEEKENDLastMinute, 6
  
  
  private
  def Orbibook.datetime_less_than(a,b)
    # is a < b
    ((b <=> a) > 0)
  end
  
end
