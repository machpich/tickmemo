class OthersidesController < ApplicationController
  before_action :authenticate_user!

  def index
    @othersides = Otherside.where(user_id:current_user.id)
  end

  def show
# <!-- 貸借管理 -->'application/total_loan', otherside: @otherside, journals: @journals
# <!-- 仕訳登録フォーム -->'application/journal_form', journal:@journal, schedules: @schedules, otherside: @form_otherside
# <!-- 関連予定 -->'application/related_schedules', related_schedules: @related_schedules
# <!-- 仕訳詳細 -->'application/journal_list', journals: @journals, otherside: @otherside, display_event: true, display_price: true, otherside_page: true,schedule_page: false, journals_page:false

    # total_loan
    @otherside = Otherside.find(params[:id])
    @journals = Journal.has_other_details(@otherside)

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

    # journal_form_select and related_schedules
    @schedules = Schedule.where(id: schedule_ids_related(@otherside).each{|id|id}).order(:start_datetime)
    @related_schedules = @schedules

# params[:c]での切り替え
    if params[:c].present?
      if params[:c] == "true"
        check = true
      elsif params[:c] == "false"
        check = false
      end

      @schedules = @schedules.where(check: check)
      @related_schedules = @schedules

      ids = @schedules.pluck(:id).uniq
      @journals = @journals.where(schedule_id: ids.each{|id|id}).new_order
    end

    # journal_list
    @journals = nil if @journals.blank?
    @sub_or_others = judge_sub_or_others(@otherside)


  end

  def edit
    @otherside = Otherside.find(params[:id])
    @otherside.memo || @otherside.build_memo

    # journal_list
    @journals = Journal.joins(:details).where(details: {otherside_id: params[:id]}).order(trade_date: :asc,id: :asc).distinct
    @journals = nil if @journals.blank?
    @sub_or_others = judge_sub_or_others(@otherside)

    # related_schedules,schedule_selecte
    @schedules = Schedule.where(id: schedule_ids_related(@otherside).each{|id|id}).order(:start_datetime)
    @related_schedules = @schedules
  end

  def update
    @otherside = Otherside.find(params[:id])
    @otherside.update(params_otherside)
    redirect_to otherside_path(@otherside)
  end

  def destroy
    @otherside = Otherside.find(params[:id])
    @otherside.destroy
    redirect_to othersides_path
  end

  private

  def params_otherside
    params.require(:otherside).permit(:otherside_name,:url,memo_attributes:[:body,:id,:_destroy])
  end
end