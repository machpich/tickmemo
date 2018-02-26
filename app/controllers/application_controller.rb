class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # application_helperを全体に反映
  helper :all

  # 遷移元を保存する
  # before_action :set_request_from

  # before_action :authenticate_user!

  private

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource_or_scope)
    index_path
  end

  # サブ取引先(true)orその他(false) ジャッジメソッド
  def judge_sub_or_others(journals)
    if journals
      @otherside = Otherside.find(params[:id])
      if journals.first.details.where(otherside_id: @otherside.id).count ==1 # 履歴が持つ明細のうち、履歴のotherside_idと明細のotherside_idが一致するものが1つかどうか(1つ＝サブ)
        return true
      else
        return false
      end
    else #journals=nilの場合
      if @otherside.schedules.empty? #scheduleは空か？（空＝サブ取引先）
        return true
      else
        return false
      end
    end


  end


end
