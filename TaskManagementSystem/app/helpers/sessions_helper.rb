# frozen_string_literal: true

module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # 現在ログイン中のユーザーを返す（いる場合）
  def current_user
    @currnt_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ユーザーがログインしていればtrue、その他ならfalse
  def logged_in?
    !current_user.nil?
  end

  # 現在のユーザーをログアウトする
  def log_out
    reset_session # 全てのセッション情報を削除
    @current_user = nil
  end
end
