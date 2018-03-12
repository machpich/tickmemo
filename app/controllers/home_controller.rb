class HomeController < ApplicationController
  before_action :authenticate_user!, except:[:top]
  # skip_before_action :authenticate_user!,only:[:top]


  def top
    # render layout: false
  end

  def setting
  end

  def search
    @schedules = Schedule.where(user_id:current_user.id).order("start_datetime desc")
  end

  def mypage
  end

end
