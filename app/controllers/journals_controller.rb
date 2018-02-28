class JournalsController < ApplicationController
  # before_action :authenticate_user!
  before_action :clean_otherside, only:[:index]

  def index
   # 'application/total_loan', otherside: nil, othersides: @othersides, journals: nil
   # 'application/journal_form', journal:@journal, schedules: @schedules, otherside: @otherside

   # 'application/journal_list', journals: @journals, otherside: @otherside, othersides:nil ,sub_or_others: @sub_or_others, display_event: true, display_price: true

   # total_loan
    @user = current_user
    @othersides = @user.othersides
    @otherside = Otherside.new
    @schedules = @user.schedules

    # journal_form
    if params[:journal].present? && Journal.where(id: params[:journal]).present?
      @journal = Journal.find(params[:journal])
    else
      @journal = Journal.new
    end
    @journal.build_memo

    # journal_list
    @journals = @user.journals
  end

  def create
    @user = current_user
    @journal = Journal.new(journal_params)
    # @journal.schedule_id = params[:schedule_id].to_i
    @journal.otherside = @journal.schedule.otherside
    @journal.user_id = @user.id

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
    # @otherside = Otherside.new

    # total_loan
    @journals = @schedule.journals
    @journals = nil if @journals.blank?
  end

  def update
    @journal = Journal.find(params[:id])
    @journal.update(journal_params)

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

  # from otherside#show CUD===============================================

  # def multicreate
  #   # schedule経由じゃない登録
  #   # journalを作成　othersideをセット　schedule_idがないため、下部で補填
  #   @journal = Journal.new(journal_params)
  #   @journal.otherside = @journal.schedule.otherside

  #   # 辞書から仕訳セットメソッド
  #   set_dict

  #   @journal.save
  #   redirect_to otherside_path(@journal.otherside)
  # end

  # def multiupdate
  #   @journal = Journal.find(params[journal:[:id]])
  #   @journal.update(journal_params)

  #   @journal.details.delete_all
  #   set_dict
  #   @journal.save
  #   redirect_to otherside_path(@journal.otherside)
  # end

  # from schedule#index CUD===============================================


  def multidestroy
    @journal = Journal.find(params[:id])
    if @journal.destroy
      redirect_back(fallback_location: root_path)
    else
      render 'othersides/show'
    end
  end

  private

  def set_dict
    @journal.trade_type.trade_account_dicts.each do |tads|
      attributes = tads.attributes.slice("position_status", "account_id")
      @detail = @journal.details.build(attributes)

      #立替金がある場合は関係者を新規作成
      if @detail.account_id == 4
        @otherside = Otherside.find_or_initialize_by(otherside_params)
        @otherside.user_id = current_user.id
        @otherside.save
        @detail.otherside = @otherside
      else
        @detail.otherside = @journal.schedule.otherside
      end
    end
  end

  def otherside_params
    params.require(:otherside).permit(:otherside_name)
  end

  def journal_params
    params.require(:journal).permit(:id,:schedule_id,:trade_date,:figure,:trade_type_id,memo_attributes:[:body,:id,:_destroy])
  end
end