# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :check_allow_ips, if: :maintenance_mode?

  def check_allow_ips
    maintenance = YAML.load_file('config/maintenance.yml')
    if maintenance['allow_ips'].present?
      return if maintenance['allow_ips'].include?(request.remote_ip)
    end
    render 'errors/503', status: 503
  end

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

  def logged_in_user
    unless logged_in?
      redirect_to login_failed_url
    end
  end

  def maintenance_mode?
    maintenance = YAML.load_file('config/maintenance.yml')
    File.exist?(maintenance['path']['lock'])
  end
end
