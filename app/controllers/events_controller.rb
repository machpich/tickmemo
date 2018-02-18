class EventsController < ApplicationController
  # before_action :authenticate_user!

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
  end

  def edit
    render layout: 'settings'
  end


  private

  def params_schedule
    params.require(:schedule).permit(:start_datetime,:end_datetime,:seat_type,:fix,:check,
                                     :location_id,:event_id,:otherside_id,:user_id,
                                     memo_attributes:[:body])
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
