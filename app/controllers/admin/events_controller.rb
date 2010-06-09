class Admin::EventsController < ApplicationController
  before_filter :authorized_admin
  
  def index
    @instruments = Instrument.all
  end
  
  def approve   
    Event.update_all(["approved=?", true], :id => params[:event_ids])
    redirect_to admin_events_path
  end
  
  def destroy    
    @event = Event.find(params[:id])
    Notifier.deliver_booking_canceled(@event)
    @event.destroy
    redirect_to admin_events_path
  end
  
end
