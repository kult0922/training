# frozen_string_literal: true

class SessionsController < ApplicationController
  attr_reader :user

  def index
    return unless logged_in?
    redirect_to controller: :tasks, action: :index
  end

  def create
    user = User.find_by(login_id: params[:login_id])
    if user.present? && user.authenticate(params[:password])
      log_in(user)
      flash[:alert] = ''
      redirect_to controller: :tasks, action: :index
    else
      flash[:alert] = 'ログインIDかパスワードを確認してください。'
      render :index
    end
  end

  def destroy
    log_out
    flash[:notice] = 'ログアウトしました。'
    redirect_to action: :index
  end

  private

  def session_params
    params.require(:user).permit(:login_id, :password)
  end
end
