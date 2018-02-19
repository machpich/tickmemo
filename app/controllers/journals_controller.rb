class JournalsController < ApplicationController
  # before_action :authenticate_user!

  def create
    @journal = Journal.new(journal_params)
    @journal.schedule_id = params[:schedule_id].to_i
    @journal.trade_type.trade_account_dicts.each do |tads|
      attributes = tads.attributes.slice("position_status", "account_id")
      @detail = @journal.details.build(attributes)
      if @detail.account_id == 4
        @otherside = Otherside.new(otherside_params)
        @otherside.user_id = current_user.id
        @otherside.save
        @detail.otherside = @otherside
      else
        @detail.otherside = @journal.schedule.otherside
      end
    end
    if @journal.save #&& @detail.save
      redirect_to schedule_path(@journal.schedule)
    else
      # render 'schedules/show'
      redirect_to schedule_path(@journal.schedule)
    end
  end


  def destroy
    @journal = Journal.find(params[:id])
    if @journal.destroy
      redirect_to schedule_path(@journal.schedule)
    else
      render 'schedules/show'
    end
  end


  private

  def otherside_params
    params.require(:otherside).permit(:otherside_name)
  end

  def journal_params
    params.require(:journal).permit(:trade_date,:figure,:trade_type_id,memo_attributes:[:body,:id,:_destroy])
  end
end
