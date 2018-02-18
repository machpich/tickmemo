class JournalsController < ApplicationController
  # before_action :authenticate_user!

  def create
    @journal = Journal.new(journal_params)
    @journal.schedule_id = params[:schedule_id].to_i
    if @journal.save
      redirect_to schedule_path(@journal.schedule)
    else
      render 'schedules/show'
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
  def journal_params
    params.require(:journal).permit(:trade_date,:figure,:trade_type_id,memo_attributes:[:body,:id,:_destroy])
  end
end
