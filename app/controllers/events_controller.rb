class EventsController < ApplicationController
  # before_action :authenticate_user!

  def show
  end

  def edit
    render layout: 'settings'
  end
end
