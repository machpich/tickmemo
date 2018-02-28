class SchedulesController < ApplicationController
  # before_action :authenticate_user!
  after_action :crean_memo, only:[:update]

  def index
    @event = Event.new
    @event.locations.build
    @schedule = @event.schedules.build
    @schedule.build_memo

    @otherside = Otherside.new

    # 未来の予定（今月から6ヶ月）のみ表示
    today = Date.today
    from = today - 1.month
    to = today + 5.month
    @schedules = Schedule.where(user_id:current_user.id).where(start_datetime:from..to).includes([:event,:otherside,:location]).order(:start_datetime)
  end

  def create
    # イベントと場所の登録
    @event = Event.find_or_initialize_by(params_event)
    if @event.persisted?
    else
    @event.user = current_user
    end

    #相手先情報の登録
    @otherside = Otherside.find_or_initialize_by(params_otherside)
    if @otherside.persisted? #すでにある場合
    else #新規保存の場合
    @otherside.user = current_user
      if @otherside.otherside_name==""
        @otherside = Otherside.where(user_id:current_user.id).find_by(otherside_name:"unknown")
      end
    end

    # 場所の登録
    @location = Location.find_or_initialize_by(params_location)
    if @location.persisted?
    else
    @location.event = @event
    end

    #スケジュールの登録
    @schedule = @event.schedules.build(params_schedule)
      @schedule.location = @location
      @schedule.otherside = @otherside
      @schedule.user = current_user
      @schedule.save

    @event.save && @otherside.save && @location.save
    redirect_to index_path
  end

  def show
    # total_loan (otherside: @sub_or_others ? nil : @schedule.otherside, othersides: nil, details: @details, sub_or_others: false, display_event: false, display_price: true)
    # journal_mini_form (schedule:@schedule, journal:@journal)
    # schedule_detail ( schedule: @schedule )
    # journal_list (journals: @schedule.journals,sub_or_others: false)

    # フォーム用
    if params[:journal].present? && Journal.where(id: params[:journal]).present?
      @journal = Journal.find(params[:journal])
    else
      @journal = Journal.new
    end
    @journal.memo || @journal.build_memo
    @otherside = Otherside.new

    # total_loan
    @schedule = Schedule.find(params[:id])
    @journals = @schedule.journals
    @journals = nil if @journals.blank?
  end

  def edit
    # フォーム用
    @schedule = Schedule.find(params[:id])
    @schedule.memo || @schedule.build_memo
    @event = @schedule.event
    @otherside = @schedule.otherside
    @location = @schedule.location

    # total_loan
    @journals = @schedule.journals
    @journals = nil if @journals.blank?
  end

  def update
    @schedule = Schedule.find(params[:id])
    @schedule.update(params_schedule)

    @event = Event.find_or_initialize_by(params_event)
    if @event.persisted?
    else
    @event.user = current_user
    end
    # create or new　を実施

    @otherside = Otherside.find_or_initialize_by(params_otherside)
    if @otherside.persisted?
    else
    @otherside.user = current_user
    end

    @location = Location.find_or_initialize_by(params_location)
    if @location.persisted?
    else
    @location.event = @event
    end

    @schedule.event = @event
    @schedule.location = @location
    @schedule.otherside = @otherside
    @schedule.user = current_user
    @schedule.save

    @event.save && @otherside.save && @location.save
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

  def edit_detail
  end

  private

  # def method_name
  #   #相手先情報の登録
  #   @otherside = Otherside.find_or_initialize_by(params_otherside)
  #   if @otherside.persisted? #すでにある場合
  #   else #新規保存の場合
  #   @otherside.user = current_user
  #     if @otherside.otherside_name==""
  #       @otherside = Otherside.where(user_id:current_user.id).find_by(otherside_name:"unknown")
  #     end
  #   end
  # end

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
