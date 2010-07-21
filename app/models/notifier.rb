class Notifier < ActionMailer::Base
  default_url_options[:host] = "calendar-msf.ucsf.edu:5150"  

  def mytest(user)
    recipients  user.email
    from        "msfCalendar@gmail.com"
    subject     "Your account has been authorized"
    body        :user => user
  end

  def password_reset_instructions(user)  
    subject       "Password Reset Instructions"  
    from          "msfCalendar@gmail.com"  
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end
  
  def account_authorized(user)
    recipients  user.email
    from        "msfCalendar@gmail.com"
    subject     "Your account has been authorized"
    body        :user => user
  end
  
  def account_suspended(user, suspender)
    recipients  user.email
    from        "msfCalendar@gmail.com"
    subject     "Your account has been authorized"
    body        :user => user, :susp => suspender
  end
  
  def booking_canceled(booking)
    recipients  booking.user.email
    from        "msfCalendar@gmail.com"
#    cc          "maltby@cgl.ucsf.edu"
    subject     "RE: Your #{booking.instrument.name} booking canceled"
    body        :event => booking
  end
  
  def instrument_delay(booking)
    recipients  booking.user.email
    from        "msfCalendar@gmail.com"
    subject     "RE: Your #{booking.instrument.name} booking delayed"
    body        :event => booking
  end

  def booking_confirmation(booking)
    recipients  booking.user.email
    from        "msfCalendar@gmail.com"
#    cc          "maltby@cgl.ucsf.edu"    
    subject     "Your #{booking.instrument.name} booking details"
    body        :event => booking
  end

  def booking_modification(booking)
    recipients  booking.user.email
    from        "msfCalendar@gmail.com"
#    cc          "maltby@cgl.ucsf.edu"    
    subject     "RE: Your #{booking.instrument.name} booking has been modified."
    body        :event => booking
  end

end
