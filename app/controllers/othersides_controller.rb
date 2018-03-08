class OthersidesController < ApplicationController

  # before_action :authenticate_user!
  def show
    # total_loan (otherside: @sub_or_others ? nil : @schedule.otherside, othersides: nil, details: @details)
    # journal_list (journals: @journals, otherside: @otherside, othersides:nil ,sub_or_others: @sub_or_others)
    # journal_form', journal:@journal, schedules: @schedules, otherside: @form_otherside

    # total_loan
    @otherside = Otherside.find(params[:id])
    @details = @otherside.details

    # journal_list
    @journals = Journal.joins(:details).where(details: {otherside_id: params[:id]}).order(trade_date: :asc,id: :asc).distinct
    @journals = nil if @journals.blank?
    @sub_or_others = judge_sub_or_others(@otherside)

    # journal_form
    if params[:journal].present? && Journal.where(id: params[:journal]).present?
      @journal = Journal.find(params[:journal])
      # 立替金の含まれる取引の場合はフォームに該当立替者を予め入れておく
      if detail = @journal.details.find_by(account_id:4)
        @form_otherside = detail.otherside
      end

    else
      @schedule = Schedule.new
      @journal = Journal.new
      @form_otherside = @sub_or_others ? Otherside.find(params[:id]) : Otherside.new
    end

      @journal.memo || @journal.build_memo
      # フォームのschedule一覧
      if @sub_or_others
        @user = current_user
        @schedules = @user.schedules
      else
        @schedules = @otherside.schedules
      end

    # 関連スケジュール一覧
    if @sub_or_others
      @related_schedules = Schedule.joins(journals:[:details]).where(details:{otherside_id: @otherside.id}).order("start_datetime").distinct
    else
      otherside = Otherside.find(params[:id])
      @related_schedules = otherside.schedules
    end
  end


  def edit
    @otherside = Otherside.find(params[:id])
    @otherside.memo || @otherside.build_memo

    # journal_list
    @journals = Journal.joins(:details).where(details: {otherside_id: params[:id]}).order(trade_date: :asc,id: :asc).distinct
    @journals = nil if @journals.blank?
    @sub_or_others = judge_sub_or_others(@otherside)

    # 関連スケジュール一覧
    if @sub_or_others
      @related_schedules = Schedule.joins(journals:[:details]).where(details:{otherside_id: @otherside.id}).order("start_datetime").distinct
    else
      otherside = Otherside.find(params[:id])
      @related_schedules = otherside.schedules
    end
  end

  def update
    @otherside = Otherside.find(params[:id])
    @otherside.update(params_otherside)
    redirect_to otherside_path(@otherside)
  end

  private

  def params_otherside
    params.require(:otherside).permit(:otherside_name,memo_attributes:[:body,:id,:_destroy])
  end
end