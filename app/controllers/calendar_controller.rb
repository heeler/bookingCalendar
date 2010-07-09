class CalendarController < ApplicationController
  before_filter :authorized_users_only
  
  def index
    @month = params[:month].to_i
    @year = params[:year].to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Event.event_strips_for_month(@shown_month)

  end
  
end