# frozen_string_literal: true

class ApplicationController < ActionController::Base
  class Forbidden < ActionController::ActionControllerError; end

  rescue_from StandardError, with: :rescue500
  rescue_from Forbidden, with: :rescue403
  rescue_from ActiveRecord::RecordNotFound, with: :rescue404

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

  def redirect_if_authorization_is_required
    redirect_to login_path if session[:user_id].blank?
  end

  def redirect_logged_in_user
    redirect_back fallback_location: root_path if session[:user_id].present?
  end
end
