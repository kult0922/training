# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper

  unless Rails.env.development?
    rescue_from StandardError, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from AbstractController::ActionNotFound, with: :render_404
  end

  def render_500(exception = nil)
    logger.error "Rendering 500 with exception: #{exception.message}" if exception
    render 'errors/500', status: 500
  end

  def render_404(exception = nil)
    logger.error "Rendering 404 with exception: #{exception.message}" if exception
    render 'errors/404', status: 404
  end

  private

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user?(user)
    user == current_user
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end
  
  def logged_in_user
    redirect_to login_failed_url unless logged_in?
  end

  def admin_only
    return if @current_user.admin?
    flash[:error] = I18n.t('errors.auth')
    redirect_to projects_path
  end
end
