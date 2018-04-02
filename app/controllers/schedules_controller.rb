class SchedulesController < ApplicationController
  before_action :authenticate_user!
  after_action :clean_memo, only:[:update]
  after_action :crean_journal_detail, only:[:update,:destroy]

  def index
    @images = Event.where(user_id:current_user.id).where.not(image_id:nil).order(created_at: :desc).distinct.limit(4)

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

    #相手先情報の登録
    @otherside = Otherside.find_or_initialize_by(params_otherside)
    otherside_create

    # 場所の登録
    @location = Location.find_or_initialize_by(params_location)

    #スケジュールの登録
    @schedule = @event.schedules.build(params_schedule)
      @schedule.location = @location
      @schedule.otherside = @otherside
      @schedule.save

    @event.save && @otherside.save && @location.save
    @event.locations << @location
    redirect_to index_path
  end

  def show
    # total_loan (otherside: @sub_or_others ? nil : @schedule.otherside, othersides: nil, details: @details, sub_or_others: false, display_event: false, display_price: true)
    # journal_mini_form (schedule:@schedule, journal:@journal)
    # schedule_detail ( schedule: @schedule )
    # journal_list (journals: @schedule.journals,sub_or_others: false)

    # schedule_form
    if params[:journal].present? && Journal.where(id: params[:journal]).present?
      @journal = Journal.find(params[:journal])
      if detail = @journal.details.find_by(account_id:4)
        @otherside = detail.otherside
      end
    else
      @journal = Journal.new
      @otherside = Otherside.new
    end
    @journal.memo || @journal.build_memo

    # total_loan
    @schedule = Schedule.find(params[:id])
    @journals = @schedule.journals
    @journals = nil if @journals.blank?

    # journal_list
    @list_journals = @schedule.journals.order('trade_date')
  end

  def edit
    index

    # scheduleフォーム用
    @schedule = Schedule.find(params[:id])
    @schedule.memo || @schedule.build_memo
    @event = @schedule.event
    @otherside = @schedule.otherside
    @location = @schedule.location

    render 'index'
  end

  def update
    # scheduleupdate
    @schedule = Schedule.find(params[:id])
    @schedule.update(params_schedule)

    @event = Event.find_or_initialize_by(params_event)

    @otherside = Otherside.find_or_initialize_by(params_otherside)
    otherside_create

    @location = Location.find_or_initialize_by(params_location)

    @schedule.event = @event
    @schedule.location = @location
    @schedule.otherside = @otherside

    if @schedule.otherside_id_changed?
      journals = @schedule.journals
      journals.update_all(otherside_id: @schedule.otherside_id)
      journals.each do |journal|
        journal.details.where(account_id: 1...3).update(otherside_id: @schedule.otherside_id)
      end
    end
    @schedule.save

    @event.save && @otherside.save && @location.save
    @event.locations << @location
    redirect_to index_path
  end

  def destroy
    @schedule = Schedule.find(params[:id])
    if @schedule.destroy
      redirect_back(fallback_location: schedules_path)
    else
      redirect_to schedules_path
    end
  end


  def destroy_from_scheule
    @schedule = Schedule.find(params[:id])
    @schedule.destroy
    redirect_to schedules_path
  end

  def copy
    index

    # form_copy
    @schedule = Schedule.new
    @schedule_old = Schedule.find(params[:id])
    @schedule.seat_type = @schedule_old.seat_type

    @event = @schedule_old.event
    @otherside = @schedule_old.otherside
    @location = @schedule_old.location
    @schedule.build_memo

    render 'index'
  end


# =========================================create json field=========================================

  def autocomplete_place_name
    locations = Location.select(:place_name).where(user_id:current_user.id).where("place_name like '%" + params[:term] + "%'").order(:location).distinct
    locations = locations.map(&:place_name)
    render json: locations.to_json
  end

  def autocomplete_program
    programs = Event.select(:program).where(user_id:current_user.id).where("program like '%" + params[:term] + "%'").order(:created_at).reverse_order.distinct
    programs = programs.map(&:program)
    render json: programs.to_json
  end

  def autocomplete_performer
    performers = Event.select(:performer).where(user_id:current_user.id).where("performer like '%" + params[:term] + "%'").order(:performer).distinct
    performers = performers.map(&:performer)
    render json: performers.to_json
  end

  def autocomplete_otherside_name
    othersides = Otherside.select(:otherside_name).where(user_id:current_user.id).where("otherside_name like '%" + params[:term] + "%'").order(:otherside_name).distinct
    othersides = othersides.map(&:otherside_name)
    render json: othersides.to_json
  end

# =========================================ajax result=========================================

  def result
    if params[:c] == "true"
      check = true
    else
      check = false
    end
    today = Date.today
    from = today - 1.month
    to = today + 5.month
    @schedules = Schedule.where(user_id:current_user.id).where(start_datetime:from..to).where(check: check).order(:start_datetime)
  end

  private

  def otherside_create
    if @otherside.persisted? #すでにある場合
    else #新規保存の場合
      if @otherside.otherside_name==""
        @otherside = Otherside.where(user_id:current_user.id).find_by(otherside_name:"unknown") || Otherside.new(otherside_name:"unknown")
      end
    @otherside.user = current_user
    end
  end

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
    params.require(:location).permit(:place_name,:user_id)
  end
end
