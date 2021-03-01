# frozen_string_literal: true

# アプリケーションコントローラー
class ApplicationController < ActionController::Base
  include Session

  helper_method :current_user

  before_action :render_maintenance, if: :maintenance_mode?

  unless Rails.env.development?
    rescue_from Exception, with: :render_500
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
  end

  def maintenance_mode?
    maintenance_file = File.open(Settings.maintenance[:file_path], 'r')
    mode = maintenance_file.read
    maintenance_file.close
    mode == Settings.maintenance[:start]
  end

  def render_maintenance
    render(
      file: Rails.public_path.join(Settings.maintenance[:page_name]),
      content_type: 'text/html',
      layout: false,
      status: :service_unavailable,
    )
  end

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def render_404(exception = nil)
    logger.info "Rendering 404 with exception: #{exception.message}" if exception
    render Settings.page_path[:not_found], status: :not_found
  end

  def render_500(exception = nil)
    logger.info "Rendering 500 with exception: #{exception.message}" if exception
    render Settings.page_path[:internal_server_error], status: :internal_server_error
  end
end
