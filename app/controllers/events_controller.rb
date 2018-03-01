class EventsController < ApplicationController
  # before_action :authenticate_user!

  # def create
  #   # イベントと場所の登録
  #   @event = Event.new(params_event)
  #   @event.user = current_user
  #   if Event.find(params[:event_name]).empty?
  #     @event.save
  #   else
  #     event_not_saved = true
  #   end

  #   #相手先情報の登録
  #   @otherside = Otherside.new(params_otherside)
  #   @otherside.user = current_user
  #   @otherside.save

  #   # 場所の登録
  #   @location = Location.new(params_location)
  #   @location.event = @event
  #   @location.save

  #   #スケジュールの登録
  #   @schedule = @event.schedules.build(params_schedule)
  #     @schedule.location = @location
  #     @schedule.otherside = @otherside
  #     @schedule.user = current_user
  #     @schedule.save

  #   redirect_to index_path
  # end

  def index
    @schedules = Schedule.where(user_id:current_user.id,event_id:params[:id]).order(:start_datetime)
  end

  def show
    @schedules = Schedule.where(user_id:current_user.id,event_id:params[:id]).order(:start_datetime)
  end


end
