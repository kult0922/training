# frozen_string_literal: true

class ApplicationController < ActionController::Base
  USER_INFO = %i[id role_id].freeze
  class Forbidden < ActionController::ActionControllerError; end

  unless Rails.env.development?
    rescue_from StandardError, with: :rescue500
    rescue_from Forbidden, with: :rescue403
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  end

  private

  def rescue500
    render 'errors/internal_server_error', status: 500
  end

  def rescue403
    render 'errors/forbidden', status: 403
  end

  def rescue404
    render 'errors/not_found', status: 404
  end

  def redirect_if_administrator_is_required
    raise ActiveRecord::RecordNotFound unless session[:role_id].eql?(Role::ROLE_ADMIN)
  end

  def redirect_if_authorization_is_required
    redirect_to login_path if session[:id].blank?
  end

  def redirect_logged_in_user
    redirect_to tasks_path if !session[:role_id].eql?(Role::ROLE_ADMIN) && session[:id].present?
  end

  def save_user_info_to_session
    USER_INFO.each do |u|
      session[u] = @user[u]
    end
  end

  def delete_user_info_in_session
    USER_INFO.each do |u|
      session.delete(u)
    end
  end
end
