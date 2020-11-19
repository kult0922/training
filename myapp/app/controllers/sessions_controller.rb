class SessionsController < ApplicationController
  skip_before_action :should_log_in

  def new
    redirect_back fallback_location: root_path if logged_in?
  end

  def create
    login_id = params[:session][:username].downcase
    user = User.find_by(name: login_id) || User.find_by(email: login_id)
    if user.present? && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      redirect_to login_path, notice: I18n.t('notice_incorrect_username_or_password')
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end

end
