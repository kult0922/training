class ApplicationController < ActionController::Base
  include ApplicationHelper, SessionsHelper

  before_action :should_log_in
  before_action -> { render503('under maintenance') }, if: :maintenance?

  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :render404
  rescue_from ActionController::RoutingError, with: :render404
  rescue_from Exception, with: :render500

  def render404(e)
    logger.warn e
    render status: :not_found, template: 'errors/404', locals: { message: 'Page Not Found' }
  end

  def render500(e)
    logger.error e
    logger.error e.backtrace.join('\n')
    render status: :internal_server_error, template: 'errors/500', locals: { message: 'Internal Server Error' }
  end

  def render503(e)
    logger.info e
    render status: :service_unavailable, template: 'errors/503', locals: { message: 'Service Unavailable' }
  end

  private

  def should_log_in
    redirect_to login_path unless logged_in?
  end

  def require_admin_privilege
    unless admin?
      render404 "unauthorized access: #{request.path} #{logged_in? ? current_user.id : '-'}"
    end
  end

  def maintenance?
    Rails.application.config.x.maintenance.enable &&
      !Rails.application.config.x.maintenance.allow_ips.any? { |ip| ip.include? request.remote_ip }
  end

end
