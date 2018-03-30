class JournalsController < ApplicationController
  before_action :authenticate_user!
  after_action :clean_memo, only:[:update]
  after_action :crean_journal_detail, only:[:update,:destroy]

  def index
# 関連予定  @related_schedules
# 貸借管理 'application/total_loan', otherside: nil, journals: nil
# 仕訳登録 'application/journal_form', journal:@journal, schedules: @schedules, otherside: @otherside
# 取引履歴 'application/journal_list', journals: @journals, otherside: nil , display_event: true, display_price: false, otherside_page:false, schedule_page:false, journals_page:true

   # total_loan
    @user = current_user
    @othersides = @user.othersides
    @schedules = @user.schedules

    # journal_form
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

    # journal_list
    @journals = @user.journals.order(trade_date: :asc,id: :asc)
    @related_schedules = @user.schedules.order(:start_datetime)


# params[:c]での切り替え
    if params[:c].present?
      if params[:c] == "true"
        check = true
      elsif params[:c] == "false"
        check = false
      end
      @schedules = @schedules.where(check: check)
      @related_schedules = @schedules
      @othersides = nil

      ids = @schedules.pluck(:id).uniq
      @journals = Journal.includes(:schedule).where(schedules:{id: ids.each{|id|id}}).new_order
    end
  end

  def create
    @journal = Journal.new(params_journal)
    @journal.otherside = @journal.schedule.otherside
    @journal.user_id = current_user.id

    # @schedule = @journal.schedule.update(params_schedule) #fix更新


    # 辞書から仕訳セットメソッド
    set_dict
    @journal.save
    redirect_back(fallback_location: root_path)
  end

  def edit
    # total_loan (otherside: @sub_or_others ? nil : @schedule.otherside, othersides: nil, details: @details, sub_or_others: false, display_event: false, display_price: true)
    # journal_mini_form (schedule:@schedule, journal:@journal)
    # schedule_detail ( schedule: @schedule )
    # journal_list (journals: @schedule.journals,sub_or_others: false)

    # フォーム用
    @schedule = Schedule.find(params[:schedule_id])
    @journal = Journal.find(params[:id])
    @journal.build_memo

    # total_loan
    @journals = @schedule.journals
    @journals = nil if @journals.blank?
  end

  def update
    @journal = Journal.find(params[:id])

    # schedule_idが変更された場合、othersideもscheduleに合わせる
    if params[:journal][:schedule_id].to_i != @journal.schedule_id
      @journal.otherside_id = @journal.schedule.otherside_id
    end

    @journal.update(params_journal)
    # @schedule = @journal.schedule.update(params_schedule) #fix更新

    @journal.details.delete_all
    set_dict
    @journal.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @journal = Journal.find(params[:id])
    if @journal.destroy
      redirect_back(fallback_location: root_path)
    else
      render 'schedules/show'
    end
  end

  private

  def set_dict
    if @journal.trade_type.trade_account_dicts.present? #メモ以外の取引を選んだ場合

      @journal.trade_type.trade_account_dicts.each do |tads|
        attributes = tads.attributes.slice("position_status", "account_id")
        @detail = @journal.details.build(attributes)

        #立替金がある場合は関係者を新規作成
        if @detail.account_id == 4
          @otherside = Otherside.find_or_initialize_by(params_otherside)

          if @otherside.persisted? #立替関係者がすでに存在する場合　なにもしない
          else #新規保存の場合
            if @otherside.otherside_name==""
              @otherside = Otherside.where(user_id:current_user.id).find_by(otherside_name:"unknown") || Otherside.new(otherside_name:"unknown")
            end
          @otherside.user = current_user
          end

          @otherside.save
          @detail.otherside = @otherside
        else
          @detail.otherside = @journal.schedule.otherside
        end
      end #each終わり
    end
  end

  def params_otherside
    params.require(:otherside).permit(:otherside_name)
  end

  def params_journal
    params.require(:journal).permit(:id,:schedule_id,:trade_date,:figure,:trade_type_id,memo_attributes:[:body,:id,:_destroy])
  end
end