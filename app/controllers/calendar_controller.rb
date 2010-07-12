class CalendarController < ApplicationController
  before_filter :authorized_users_only
  
  def index
    @month = params[:month].to_i
    @year = params[:year].to_i
    @shown_month = Date.civil(@year, @month)
    @event_strips = Event.event_strips_for_month(@shown_month)

    set_object_to_inst_color

  end
  
  private
  
  def set_object_to_inst_color
    @event_strips.each do |day|
      day.each do |evnt|
        next if evnt.nil?
        class << evnt
          include RailsExtensions::EventInstrumentColor
        end
      end
    end
    
  end
  
end

