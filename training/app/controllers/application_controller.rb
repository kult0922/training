class ApplicationController < ActionController::Base
  include ErrorHandlers if Rails.env.production?
  before_action :authorize

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user
  end

  def authorize
    unless current_user
      redirect_to new_sessions_path, alert: t('sessions.flash.not_authrize')
    end
  end

  helper_method :current_user, :logged_in?
end
