class ApplicationController < ActionController::Base
  include SessionsHelper

  if Rails.env.production?
    before_action :render503_except_for_whitelisted_ips, if: :maintenance_mode
  end

  unless Rails.env.development?
    rescue_from StandardError, with: :render500
    rescue_from ActionController::RoutingError, with: :render404
    rescue_from ActiveRecord::RecordNotFound, with: :render404
  end

  def render404(exception = nil)
    logger.error "Rendering 404 with exception: #{exception.message}" if exception
    render 'errors/404', layout: 'error', status: :not_found
  end

  def render500(exception = nil)
    logger.error "Rendering 500 with exception: #{exception.message}" if exception
    render 'errors/500', layout: 'error', status: :internal_server_error
  end

  def render503_except_for_whitelisted_ips
    ips_in_whitelist = (ENV["ALLOWED_IPS"] || "").split(",")
    return if ips_in_whitelist.include?(request.remote_ip)
    render 'errors/503', layout: 'error', status: :service_unavailable
  end

  private

  def logged_in_user
    redirect_to login_url unless logged_in?
  end

  def only_admin
    redirect_to root_url unless admin?
  end

  def maintenance_mode?
    File.exist?('tmp/maintenance.txt')
  end
end
