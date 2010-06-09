class InstrumentsController < ApplicationController   
  before_filter :logged_in, :except => [:index, :show]
  
  # GET /instruments
  # GET /instruments.xml
  def index
    @instruments = Instrument.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @instruments }
    end
  end

  # GET /instruments/1
  # GET /instruments/1.xml
  def show
    @instrument = Instrument.find(params[:id])
    @message = @instrument.messages.last

    @month = params[:month].to_i if params[:month]
    @year = params[:year].to_i if params[:year]
    
    @month =  @month || DateTime.now.month 
    @year = @year || Time.now.year
    @shown_month = Date.civil(@year, @month)
    #@event_strips = Event.event_strips_for_month(@shown_month)
    @event_strips = @instrument.events.event_strips_for_month(@shown_month)
    
    #@events = @instrument.events
    #@date = Time.parse("#{params[:start_date]} || Time.now.utc")
   # @start_date = Date.new(@date.year, @date.month, @date.day)    
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @instrument }
    end
  end

  # GET /instruments/new
  # GET /instruments/new.xml
  def new
    @instrument = Instrument.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @instrument }
    end
  end

  # GET /instruments/1/edit
  def edit
    @instrument = Instrument.find(params[:id])
  end

  # POST /instruments
  # POST /instruments.xml
  def create
    @instrument = Instrument.new(params[:instrument])

    respond_to do |format|
      if @instrument.save
        flash[:notice] = 'Instrument was successfully created.'
        format.html { redirect_to(@instrument) }
        format.xml  { render :xml => @instrument, :status => :created, :location => @instrument }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @instrument.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /instruments/1
  # PUT /instruments/1.xml
  def update
    @instrument = Instrument.find(params[:id])

    respond_to do |format|
      if @instrument.update_attributes(params[:instrument])
        flash[:notice] = 'Instrument was successfully updated.'
        format.html { redirect_to(@instrument) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @instrument.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /instruments/1
  # DELETE /instruments/1.xml
  def destroy
    @instrument = Instrument.find(params[:id])
    @instrument.destroy

    respond_to do |format|
      format.html { redirect_to(instruments_url) }
      format.xml  { head :ok }
    end
  end
end
