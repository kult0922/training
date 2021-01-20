# frozen_string_literal: true

# アプリケーションコントローラー
class ApplicationController < ActionController::Base
  before_action :render_maintenance, if: :maintenance_mode?

  rescue_from Exception, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

  def maintenance_mode?
    maintenance_file = File.open(Settings.maintenance[:file], 'r')
    mode = maintenance_file.read
    maintenance_file.close

    mode = mode.delete("\n") if mode.present?
    mode == '1'
  end

  def render_maintenance
    render(
      file: Rails.public_path.join('maintenance.html'),
      content_type: 'text/html',
      layout: false,
      status: :service_unavailable
    )
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def render_404(exception = nil)
    logger.info "404 with exception: #{exception.message}" if exception
    render 'errors/404', status: :not_found
  end

  def render_500(exception = nil)
    logger.info "500 with exception: #{exception.message}" if exception
    render 'errors/500', status: :internal_server_error
  end

  private

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id) if session[:user_id]
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def admin_user?(user)
    return false if user.nil?

    login_user_auth = Authority.select(:role)
                               .find_by(id: user.authority_id)
    login_user_auth.role == Settings.authority[:admin]
  end

  def general_user?(user)
    return false if user.nil?

    login_user_auth = Authority.select(:role)
                               .find_by(id: user.authority_id)
    login_user_auth.role >= Settings.authority[:general]
  end
end
