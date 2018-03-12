class HomeController < ApplicationController
  before_action :authenticate_user!, except:[:top]
  # skip_before_action :authenticate_user!,only:[:top]


  def top
    # render layout: false
  end

  def setting
  end

  def search
    @q = Schedule.where(user_id:current_user.id).search(params[:q])
    @schedules = @q.result(distinct: true)
  end

  def mypage
  end

  private
  def search_params
    params.require(:q).permit!
  end
end
