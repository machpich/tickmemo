class HomeController < ApplicationController
  skip_before_action :authenticate_user!,only:[:top]


  def top
  end

  def setting
  end

  def search
  end

  def mypage
  end

end
