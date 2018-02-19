class JournalsController < ApplicationController
  # before_action :authenticate_user!

  def create
    @journal = Journal.new(journal_params)
    @journal.schedule_id = params[:schedule_id].to_i
    @journal.trade_type.trade_account_dicts.each do |tads|
      attributes = tads.attributes.slice("position_status", "account_id")
      @detail = @journal.details.build(attributes)
      # if @detail.account_id == 4
      #   @otherside = Otherside.create(otherside_params)
      #   @detail.otherside = @otherside
      # else
        @detail.otherside = @journal.schedule.otherside
      # end
    end
    if @journal.save #&& @detail.save
      redirect_to schedule_path(@journal.schedule)
    else
      # render 'schedules/show'
      redirect_to schedule_path(@journal.schedule)
    end
  end

  # create_table "details", force: :cascade do |t|
  #   t.integer "position_status"
  #   t.integer "account_id"
  #   t.integer "otherside_id"

  #  create_table "details_journals", id: false, force: :cascade do |t|
  #   t.integer "detail_id", null: false
  #   t.integer "journal_id", null: false

  #   create_table "trade_account_dicts", force: :cascade do |t|
  #   t.integer "position_status"
  #   t.integer "trade_type_id"
  #   t.integer "account_id"


  def destroy
    @journal = Journal.find(params[:id])
    if @journal.destroy
      redirect_to schedule_path(@journal.schedule)
    else
      render 'schedules/show'
    end
  end


  private

  # def otherside
  #   params.require(:otherside).permit(:name)
  # end

  def journal_params
    params.require(:journal).permit(:trade_date,:figure,:trade_type_id,memo_attributes:[:body,:id,:_destroy])
  end
end
