class ApplicationController < ActionController::Base
  include SessionsHelper
  include UsersHelper

  unless Rails.env.development?
    rescue_from StandardError, with: :render500
    rescue_from ActionController::RoutingError, with: :render404
    rescue_from ActiveRecord::RecordNotFound, with: :render404
  end

  def render404(exception = nil)
    logger.error "Rendering 404 with exception: #{exception.message}" if exception
    render 'errors/404', status: :not_found
  end

  def render500(exception = nil)
    logger.error "Rendering 500 with exception: #{exception.message}" if exception
    render 'errors/500', status: :internal_server_error
  end

  private

  def logged_in_user
    redirect_to login_url unless logged_in?
  end

  def only_admin
    redirect_to root_url unless admin?
  end
end
