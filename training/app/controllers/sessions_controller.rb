class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: t('sessions.flash.create')
    else
      redirect_to new_session_path, alert: t('sessions.flash.create_fail')
    end
  end
end
