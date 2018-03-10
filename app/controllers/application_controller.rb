class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # application_helperを全体に反映
  helper :all

  # before_action :authenticate_user!

  private

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource_or_scope)
    index_path
  end

  # 紐付けのないmemoを削除
  def clean_memo
    memos = Memo.where(body:"")
    memos.delete_all
  end

  def clean_parts
    user = current_user
    # otherside_clear
    user.othersides.includes(:schedules,:journals,:details).each do |otherside|
      if otherside.schedules.empty? && otherside.journals.empty? && otherside.details.empty?
        otherside.destroy
      end
    end
    # detail_clear 親(journals)の居ないdetailsを削除
    user.othersides.each do |otherside|
      if otherside.details.present?
        if otherside.details.first.journal.nil?
          otherside.details.first.destroy
        end
        if otherside.details.last.journal.nil?
          otherside.details.last.destroy
        end
      end
    end
    # journal_clear
    user.journals.each do |journal|
      if journal.schedule.nil?
        journal.destroy
      end
    end
    # event_clear
    user.events.each do |event|
      if event.schedules.empty?
        event.destroy
      end
    end
    # location_clear
    user.locations.each do |location|
      if location.schedules.empty?
        location.destroy
      end
    end
  end

  def judge_sub_or_others(otherside)
    if Detail.where(otherside_id: otherside.id).any? && Journal.where(otherside_id: otherside.id).empty?
      true
    elsif Detail.where(otherside_id: otherside.id).empty? && Journal.where(otherside_id: otherside.id).empty? && Schedule.where(otherside_id: otherside.id).any?
      false
    else
      false
    end
  end

end
