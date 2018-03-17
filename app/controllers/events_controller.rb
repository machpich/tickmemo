class EventsController < ApplicationController
  before_action :authenticate_user!
  after_action :clean_memo, only:[:update]

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
    # @schedules = Schedule.where(user_id:current_user.id,event_id:params[:id]).order(start_datetime: :desc)
    @events = Event.where(user_id: current_user.id).order(created_at: :desc)
  end

  def show
    @event = Event.find(params[:id])
    @schedules = Schedule.where(user_id:current_user.id,event_id:params[:id]).order(:start_datetime)
  end

  def edit
    @event = Event.find(params[:id])
    @event.memo || @event.build_memo
  end

  def update
    @event = Event.find(params[:id])
    @event.update(params_event)
    redirect_to event_path(@event)
  end

  private

  def params_event
    params.require(:event).permit(:user_id,:program,:performer,:date_start,:date_end,:url,:image,:remove_image,memo_attributes:[:id,:_destroy,:body])
  end
end
