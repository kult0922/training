class SessionsController < ApplicationController
  skip_before_action :authorize

  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: t('sessions.flash.create')
    else
      redirect_to new_sessions_path, alert: t('sessions.flash.create_fail')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_sessions_path, notice: t('sessions.flash.destroy')
  end
end
