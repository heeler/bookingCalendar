class MessagesController < ApplicationController
  before_filter :logged_in

  # GET /messages
  # GET /messages.xml
  def index
    @messages = Message.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end


  # GET /messages/new
  # GET /messages/new.xml
  def new
    @instrument = Instrument.find(params[:instrument_id])
    @message = @instrument.messages.new 

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end


  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    @instrument = @message.instrument
    
    respond_to do |format|
      if @message.save
        flash[:notice] = 'Message was successfully created.'
        format.html { redirect_to(instrument_path(@instrument)) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end



  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    @message.destroy

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
end
