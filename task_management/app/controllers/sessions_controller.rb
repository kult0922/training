# frozen_string_literal: true

# セッションコントローラー
class SessionsController < ApplicationController
  attr_reader :user

  def index
    # ログインユーザーによって遷移先画面を切り変える
    redirect_to_user_page
  end

  def create
    user = User.select(:id, :name, :authority_id)
               .find_by(login_id: params[:login_id],
                        password: params[:password])
    if user.nil?
      flash[:alert] = I18n.t('sessions.flash.error.create')
      render :index
    else
      log_in(user)
      flash[:alert] = ''
      redirect_to_user_page
    end
  end

  def destroy
    log_out
    flash[:notice] = I18n.t('sessions.flash.success.delete')
    redirect_to action: :index
  end

  private

  def redirect_to_user_page
    # ログインしていない場合、他ページにリダイレクトしない
    return unless logged_in?

    return redirect_to admin_users_path if admin_user?(current_user)
    redirect_to tasks_path if general_user?(current_user)
  end

  def session_params
    params.require(:user).permit(:login_id, :password)
  end
end
