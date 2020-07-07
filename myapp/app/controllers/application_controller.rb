class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :find_maintenance, if: :under_maintenance?
  unless Rails.env.development?
    rescue_from StandardError, with: :rescue500
    rescue_from RuntimeError, with: :rescue500
    rescue_from ActionController::RoutingError, with: :rescue404
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  end

  def rescue404
    render 'errors/not_found', status: 404
  end

  def rescue500
    render 'errors/internal_server_error', status: 500
  end

  def require_login
    unless logged_in?
      flash[:danger] = t 'flash.danger'
      redirect_to login_path
    end
  end

  def under_maintenance?
    File.exist?('tmp/maintenance.yml')
  end

  def find_maintenance
    render 'maintenance/index', layout: false
  end
end
