class HomeController < ApplicationController
  # skip_before_action :authenticate_user!,only:[:top]


  def top
    # render layout: false
  end

  def setting
    render layout: 'settings'
  end

  def search
    @schedules = Schedule.where(user_id:current_user.id)
  end

  def mypage
  end

end
