require 'test_helper'

class EventTest < ActiveSupport::TestCase
  fixtures :instruments, :users
  setup :activate_authlogic
  
  def setup
    UserSession.create(users(:heeler))
  end

  test "the_truth" do
    assert true
  end
  
  test "should_orbi_create_event" do
    event = orbi_create
    assert event.al_approved, "Event should be Al Approved but isn't!"
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_not_create_daytime_orbi_booking_monday" do
    event = orbi_create({:start_at => "2010-07-05 12:00:00", :duration => 3.hours })
    deny event.valid?, "Shouldn't have been able to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_8_hour_orbi_booking_monday" do
    event = orbi_create({:start_at => "2010-07-05 16:00:00", :duration => 8.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
    assert event.start_at.hour == 16
    assert event.start_at.zone == "PDT", "Time zone is #{event.start_at.zone} not PDT."
    test_time = (Time.zone.parse("2010-07-05 16:00:00") + 8.hours - 1)
    assert event.end_at == test_time , "Time not assigning correctly\n#{event.end_at} not equal to #{test_time}"
  end
  
  test "should_create_16_hour_orbi_booking_monday" do
    event = orbi_create({:start_at => "2010-07-05 16:00:00", :duration => 16.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_8_hour_orbi_booking_tuesday" do
    event = orbi_create({:start_at => "2010-07-06 16:00:00", :duration => 8.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_16_hour_orbi_booking_tuesday" do
    event = orbi_create({:start_at => "2010-07-06 16:00:00", :duration => 16.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_8_hour_orbi_booking_wednesday" do
    event = orbi_create({:start_at => "2010-07-07 16:00:00", :duration => 8.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_16_hour_orbi_booking_wednesday" do
    event = orbi_create({:start_at => "2010-07-07 16:00:00", :duration => 16.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_8_hour_orbi_booking_thursday" do
    event = orbi_create({:start_at => "2010-07-08 16:00:00", :duration => 8.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_16_hour_orbi_booking_thursday" do
    event = orbi_create({:start_at => "2010-07-08 16:00:00", :duration => 16.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_10_hour_orbi_booking_friday" do
    event = orbi_create({:start_at => "2010-07-09 16:00:00", :duration => 10.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_20_hour_orbi_booking_friday" do
    event = orbi_create({:start_at => "2010-07-09 16:00:00", :duration => 20.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_11_hour_orbi_booking_saturday" do
    event = orbi_create({:start_at => "2010-07-10 12:00:00", :duration => 11.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_22_hour_orbi_booking_saturday" do
    event = orbi_create({:start_at => "2010-07-10 12:00:00", :duration => 22.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end  
  
  test "should_create_11_hour_orbi_booking_sunday" do
    event = orbi_create({:start_at => "2010-07-11 10:00:00", :duration => 11.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_22_hour_orbi_booking_sunday" do
    event = orbi_create({:start_at => "2010-07-11 10:00:00", :duration => 22.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  # Instrument 2 bookings
  
  test "should_create_8_hour_elite_booking_monday" do
    event = elite_create({:start_at => "2010-07-05 16:00:00", :duration => 8.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
    assert event.start_at.hour == 16
  end
  
  test "should_create_16_hour_elite_booking_monday" do
    event = elite_create({:start_at => "2010-07-05 16:00:00", :duration => 16.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_8_hour_elite_booking_tuesday" do
    event = elite_create({:start_at => "2010-07-06 16:00:00", :duration => 8.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_16_hour_elite_booking_tuesday" do
    event = elite_create({:start_at => "2010-07-06 16:00:00", :duration => 16.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_8_hour_elite_booking_wednesday" do
    event = elite_create({:start_at => "2010-07-07 16:00:00", :duration => 8.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_16_hour_elite_booking_wednesday" do
    event = elite_create({:start_at => "2010-07-07 16:00:00", :duration => 16.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_8_hour_elite_booking_thursday" do
    event = elite_create({:start_at => "2010-07-08 16:00:00", :duration => 8.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_16_hour_elite_booking_thursday" do
    event = elite_create({:start_at => "2010-07-08 16:00:00", :duration => 16.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_10_hour_elite_booking_friday" do
    event = elite_create({:start_at => "2010-07-09 16:00:00", :duration => 10.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_20_hour_elite_booking_friday" do
    event = elite_create({:start_at => "2010-07-09 16:00:00", :duration => 20.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_11_hour_elite_booking_saturday" do
    event = elite_create({:start_at => "2010-07-10 12:00:00", :duration => 11.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_22_hour_elite_booking_saturday" do
    event = elite_create({:start_at => "2010-07-10 12:00:00", :duration => 22.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end  
  
  test "should_create_11_hour_elite_booking_sunday" do
    event = elite_create({:start_at => "2010-07-11 10:00:00", :duration => 11.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  test "should_create_22_hour_elite_booking_sunday" do
    event = elite_create({:start_at => "2010-07-11 10:00:00", :duration => 22.hours })
    assert event.valid?, "Unable to create event:\n#{event.to_yaml}"
  end
  
  #extend tests
  test "should_create_bookings_2_hour_ago_for_10_hours_and_extend" do
    tm = Time.now
    start_at = tm.at_midnight + tm.hour - 2.hours
    eventOne = ft_create({:start_at => start_at, :duration => 10.hours })
    assert eventOne.valid?, "Unable to create event:\n#{eventOne.to_yaml}"
    start_at += 18.hours
    eventTwo = ft_create({:start_at => start_at, :duration => 10.hours })
    assert eventTwo.valid?, "Unable to create second event:\n#{eventTwo.to_yaml}"
    eventOne.extend_booking(3)
    assert eventOne.valid?, "Unable to extend:\n#{eventOne.to_yaml}"
  end
  
  test "should_create_bookings_2_hour_ago_for_10_hours_and_extend_longer" do
    tm = Time.now
    start_at = tm.at_midnight + tm.hour - 2.hours
    eventOne = ft_create({:start_at => start_at, :duration => 10.hours })
    assert eventOne.valid?, "Unable to create event:\n#{eventOne.to_yaml}"
    start_at += 18.hours
    eventTwo = ft_create({:start_at => (start_at + 8.hours), :duration => 10.hours })
    assert eventTwo.valid?, "Unable to create second event:\n#{eventTwo.to_yaml}"
    eventOne.extend_booking(10)
    assert eventOne.valid?, "Unable to extend:\n#{eventOne.to_yaml}"
  end
  
  private
  
  def orbi_create(options={})
    create(options, instruments(:ltq_orbitrap))
  end
  
  def elite_create(options={})
    create(options, instruments(:qstar_elite))
  end
  
  def ft_create(options={})
    create(options, instruments(:ltq_ft))
  end
  
  def create(options,inst)
    evnt = inst.events.create(@@event_default_values.merge(options))
  end
end
