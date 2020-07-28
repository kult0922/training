class ApplicationController < ActionController::Base
  before_action :render503_except_for_whitelisted_ips, if: :maintenance_mode?
  before_action :login_required
  helper_method :current_user

  rescue_from Exception, with: :render500
  rescue_from ActionController::RoutingError, with: :render404
  rescue_from ActiveRecord::RecordNotFound, with: :render404

  def maintenance_mode?
    File.exist? 'tmp/maintenance.yml'
  end

  def render404(exception = nil)
    logger.error "404 error: #{exception.message}" if exception
    render 'errors/404', status: :not_found
  end

  def render500(exception = nil)
    logger.error "500 error: #{exception.message}" if exception
    render 'errors/500', status: :internal_server_error
  end

  def render503_except_for_whitelisted_ips
    yaml = YAML.load_file('tmp/maintenance.yml')
    ips_in_whitelist = (yaml['allowed_ips'] || '').split(',')
    return if ips_in_whitelist.include?(request.remote_ip)
    render 'errors/503', status: :service_unavailable
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_path unless current_user
  end
end
