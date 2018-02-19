class SchedulesController < ApplicationController
  # before_action :authenticate_user!

  def index
    @event = Event.new
    @event.locations.build
    @schedule = @event.schedules.build
    @schedule.build_memo

    @otherside = Otherside.new

    @schedules = Schedule.where(user_id:current_user.id).order(:start_datetime)
  end

  def show
    @schedule = Schedule.find(params[:id])
    @journal = Journal.new
    @journal.build_memo
    @otherside = Otherside.new
  end



end
