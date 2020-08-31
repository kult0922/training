# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    blocked_double_login
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def create
    user = User.find_by(account_name: params[:session][:account_name])
    if user&.authenticate(params[:session][:password])
      log_in user
      redirect_to projects_url
    else
      flash.now[:error] = 'ログイン失敗'
      render 'new'
    end
  end

  def fail
  end

  def blocked_double_login
    if logged_in?
      redirect_to projects_path
    end
  end
end
