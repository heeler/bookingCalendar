class EventsController < ApplicationController           
  before_filter :check_authorized, :except => :duration

  def show
    @event = @instrument.events.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def new
    @event = @instrument.events.new

    respond_to do |format|
      format.html # new.html.erb
      #format.js { render :action => 'new.js.rjs'}
      format.xml  { render :xml => @event }
    end
  end

  def edit
    @event = @instrument.events.find(params[:id])
    @dt = @event.start_at
  end

  def create
    @event = @instrument.events.new(params[:event])
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
      #  Notifier.deliver_booking_confirmation(@event)
        format.html { redirect_to instrument_path(@instrument) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => 'new' }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        Notifier.deliver_booking_modification(@event)
        format.html { redirect_to instrument_path(@instrument) }
        format.xml  { head :ok }
      else
        flash[:error] = 'conflict unable to move your booking to your desired time'
        format.html { redirect_to instrument_path(@instrument) }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = @instrument.events.find(params[:id])    
    Notifier.deliver_booking_canceled(@event)
    @event.destroy
    flash[:notice] = 'Booking(s) removed and users notified by email.'
    respond_to do |format|
      format.html { redirect_to instrument_path(@instrument) }
      format.xml  { head :ok }
    end
  end
  
  def duration
    @dt = DateTime.parse(params[:time])
  end
  
  def extend
    @event = @instrument.events.find(params[:id])
    if @event.in_progress?
      changed_events = @event.extend_booking(params[:event][:duration])
      changed_events.each {|ev| Notifier.deliver_instrument_delay(ev) }
      flash[:notice] = 'Your Booking was extended and others users shifted.'
    else
      flash[:error] = 'Events can only be edited while they are active.'
    end
    redirect_to instrument_path(@instrument)         
  end
  
  private

  def check_authorized
    redirect_to instruments_path unless authorized_user || (!@instrument.msf_only && current_user.walkup) 
    @day = @day || Time.now.at_midnight
    @instrument = @instrument || Instrument.find(params[:instrument_id])
  end
  
end
