# frozen_string_literal: true

# セッションコントローラー
class SessionsController < ApplicationController
  attr_reader :user

  def index
    # TODO: セッションのログインユーザーによって遷移先画面を切り変える
    # 現状、ログインしていたらそこで処理終了する
    return unless logged_in?
    redirect_to_user_page
  end

  # TODO: 各コントローラのフラッシュメッセージのjaファイル化
  def create
    user = User.select(:id, :name, :authority_id)
               .find_by(login_id: params[:login_id],
                        password: params[:password])
    if user.nil?
      flash[:alert] = 'ログインIDかパスワードを確認してください。'
      render :index
    else
      log_in(user)
      flash[:alert] = ''
      redirect_to_user_page
    end
  end

  def destroy
    log_out
    flash[:notice] = 'ログアウトしました。'
    redirect_to action: :index
  end

  private

  def redirect_to_user_page
    redirect_path = tasks_path

    if current_user.authority_id == Settings.authority[:admin]
      redirect_path = admin_users_path
    end

    redirect_to redirect_path
  end

  def session_params
    params.require(:user).permit(:login_id, :password)
  end
end
