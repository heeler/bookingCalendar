class EventsController < ApplicationController           
  before_filter :logged_in
  before_filter :check_authorized


  # GET /events/1
  # GET /events/1.xml
  def show
    @instrument = Instrument.find(params[:instrument_id])
    @event = @instrument.events.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @instrument = Instrument.find(params[:instrument_id])
    @event = @instrument.events.new
    @day = @day || Time.now.at_midnight

    respond_to do |format|
      format.html # new.html.erb
      #format.js { render :action => 'new.js.rjs'}
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @instrument = Instrument.find(params[:instrument_id])
    @event = @instrument.events.find(params[:id])
    @day = @day || Time.now.at_midnight
    @dt = @event.start_at
  end

  # POST /events
  # POST /events.xml
  def create
    @instrument = Instrument.find(params[:instrument_id])    
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

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @instrument = Instrument.find(params[:instrument_id])
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        Notifier.deliver_booking_modification(@event)
        format.html { redirect_to instrument_path(@instrument) }
        format.xml  { head :ok }
      else
        # dupoldevent.save
        flash[:error] = 'conflict unable to move your booking to your desired time'
        format.html { redirect_to instrument_path(@instrument) }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @instrument = Instrument.find(params[:instrument_id])
    @event = @instrument.events.find(params[:id])
    
    Notifier.deliver_booking_canceled(@event)
    
    @event.destroy
    flash[:notice] = 'Booking(s) removed and users notified by email.'
    respond_to do |format|
      format.html { redirect_to instrument_path(@instrument) }
      format.xml  { head :ok }
    end
  end
  
  def approve
    Event.update_all(["approved=?", true], :id => params[:event_ids])
    # TODO mark all selected booking as approved.
    redirect_to instruments_path
  end          

  def time
    @dt = DateTime.parse(params[:time]) 
  end

  def duration
    @dt = DateTime.parse(params[:time])
  end
  
  def extend
    @instrument = Instrument.find(params[:instrument_id])
    @event = @instrument.events.find(params[:id])
    if @event.in_progress?
      changed_events = @event.extend_booking(params[:event][:duration])
      changed_events.each {|ev| Notifier.deliver_instrument_delay(ev) }
  #    redirect_to instrument_event_path(@instrument, @event) 
      flash[:notice] = 'Your Booking was extended and others users shifted.'
    else
      flash[:error] = 'Events can only be edited while they are active.'
    end
    redirect_to instrument_path(@instrument)         
  end
  
  private

  def check_authorized
    redirect_to instruments_path unless authorized_user
  end
  
end
