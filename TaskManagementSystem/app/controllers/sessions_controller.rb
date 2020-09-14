# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user&.authenticate(params[:password])
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in(user)
      redirect_to root_path, success: I18n.t('flash.login')
    else
      flash.now[:danger] = I18n.t('flash.login_failed')
      render :new
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
