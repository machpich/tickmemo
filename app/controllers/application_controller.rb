class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :authenticate_user!

  private

  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource_or_scope)
    index_path
  end

end
