# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :login

  def new
  end

  def create
    user = User.find_by(email: session_params[:email])
    if user&.authenticate(session_params[:password])
      reset_session
      session[:user_id] = user.id
      redirect_to tasks_path
    else
      redirect_to new_session_path, alert: t('message.session.create.failed')
    end
  end

  def destroy
    reset_session
    redirect_to new_session_path, notice: t('message.session.destroy.succeeded')
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
