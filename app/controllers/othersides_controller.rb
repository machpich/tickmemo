class OthersidesController < ApplicationController
  # before_action :authenticate_user!
  def show
    # total_loan (otherside: @sub_or_others ? nil : @schedule.otherside, othersides: nil, details: @details)
    # journal_form (journal:@journal)
    # journal_list (journals: @journals, otherside: @otherside, othersides:nil ,sub_or_others: @sub_or_others)

    # total_loan
    @otherside = Otherside.find(params[:id])
    @details = @otherside.details

    # journal_list
    @journals = Journal.joins(:details).where(details: {otherside_id: params[:id]}).order(:trade_date).distinct
    @journals = nil if @journals.blank?
    @sub_or_others = judge_sub_or_others(@journals)

    # journal_form
    @schedule = Schedule.new
    @journal = Journal.new
    @journal.build_memo
    # フォームのschedule一覧
    if @sub_or_others #サブの場合
      @user = current_user
      @schedules = @user.schedules
    else #メインの場合
      @schedules = @otherside.schedules
    end

    @related_schedules = @schedules

    # 関連スケジュール一覧
    # @related_schedules = Schedule.joins(journals: :details).where(details: {otherside_id: params[:id]}).distinct
  end


  def edit
    render layout: 'settings'
  end

end