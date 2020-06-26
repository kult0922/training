class ApplicationController < ActionController::Base
  include SessionHundle

  before_action :render503_except_for_whitelisted_ips, if: :maintenance_mode # if Rails.env.production?

  unless Rails.env.development?#
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
    ips_in_whitelist = YAML.load_file('config/maintenance.yml')
    if ips_in_whitelist['allow_ips'].present?
      return if ips_in_whitelist['allow_ips'].include?(request.remote_ip)
    end
    render 'errors/503', layout: 'error', status: :service_unavailable
  end

  private

  def maintenance_mode
    File.exist?('tmp/maintenance.txt')
  end
end
