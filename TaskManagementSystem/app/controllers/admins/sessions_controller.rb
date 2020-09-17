class Admins::SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password]) && user.user_roles.find_by(role_id: 1).present?
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in(user)
      redirect_to admins_users_path, success: I18n.t('flash.login')
    else
      flash.now[:danger] = I18n.t('flash.login_failed')
      render :new
    end
  end

  def destroy
    log_out
    redirect_to admin_login_path
  end
end
