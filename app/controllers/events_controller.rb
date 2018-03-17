class EventsController < ApplicationController
  before_action :authenticate_user!
  after_action :clean_memo, only:[:update]

  def index
    @events = Event.where(user_id: current_user.id).order(created_at: :desc)
  end

  def show
    @event = Event.find(params[:id])
    @schedules = Schedule.where(user_id:current_user.id,event_id:params[:id]).order(:start_datetime).page(params[:page])
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
