class SchedulesController < ApplicationController
  # before_action :authenticate_user!

  def index
    @event = Event.new
    @event.locations.build
    @schedule = @event.schedules.build
    @schedule.build_memo

    @otherside = Otherside.new

    @schedules = Schedule.where(user_id:current_user.id).includes([:event,:otherside,:memo,:location]).order(:start_datetime)
  end

  def create
    # イベントと場所の登録
    @event = Event.new(params_event)
    @event.user = current_user
    @event.save

    #相手先情報の登録
    @otherside = Otherside.new(params_otherside)
    @otherside.user = current_user
    @otherside.save

    # 場所の登録
    @location = Location.new(params_location)
    @location.event = @event
    @location.save

    #スケジュールの登録
    @schedule = @event.schedules.build(params_schedule)
      @schedule.location = @location
      @schedule.otherside = @otherside
      @schedule.user = current_user
      @schedule.save

    redirect_to index_path
  end

  def show
    @schedule = Schedule.find(params[:id])
    @journal = Journal.new
    @journal.build_memo
    @otherside = Otherside.new

    @array = []
  end

  def edit
    @schedule = Schedule.find(params[:id])
    @event = @schedule.event
    @otherside = @schedule.otherside
    @location = @schedule.location

    @array = []
  end

  def update
    @schedule = Schedule.find(params[:id])
    @schedule.update(params_schedule)

    @event = @schedule.event
    @event.update(params_event)
    # create or new　を実施

    @otherside = @schedule.otherside
    @otherside.update(params_otherside)

    @location = @schedule.location
    @location.update(params_location)

    redirect_to index_path
  end

  def destroy
    @schedule = Schedule.find(params[:id])
    if @schedule.destroy
      flash[:notice] = "削除しました"
      redirect_to schedules_path
    else
      flash[:alert] = "削除に失敗しました"
    end
  end

  private

  def params_schedule
    params.require(:schedule).permit(:start_datetime,:end_datetime,:seat_type,:fix,:check,
                                     :location_id,:event_id,:otherside_id,:user_id,
                                     memo_attributes:[:body,:id,:_destroy])
  end

  def params_event
    params.require(:event).permit(:program,:performer,:user_id)
  end

  def params_otherside
    params.require(:otherside).permit(:otherside_name,:user_id)
  end

  def params_location
    params.require(:location).permit(:place_name,:event_id)
  end

end
