class SchedulesController < ApplicationController
  # before_action :authenticate_user!

  def index
    @event = Event.new
    @event.locations.build
    @schedule = @event.schedules.build
    @schedule.build_memo

    @otherside = Otherside.new
  end



  def show
  end



end
