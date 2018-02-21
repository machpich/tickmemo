class OthersidesController < ApplicationController
  # before_action :authenticate_user!
  def show
    @otherside = Otherside.find(params[:id])
    @schedules = @otherside.schedules
    @journals = @otherside.journals

    @schedule = Schedule.new
    @journal = Journal.new
    @journal.build_memo
  end

  def edit
    render layout: 'settings'
  end
end
