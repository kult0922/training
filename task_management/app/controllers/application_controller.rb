class ApplicationController < ActionController::Base
  before_action :login_required
  helper_method :current_user

  rescue_from Exception, with: :render500
  rescue_from ActionController::RoutingError, with: :render404
  rescue_from ActiveRecord::RecordNotFound, with: :render404

  def render404(exception = nil)
    logger.error "404 error: #{exception.message}" if exception
    render 'errors/404', status: :not_found
  end

  def render500(exception = nil)
    logger.error "500 error: #{exception.message}" if exception
    render 'errors/500', status: :internal_server_error
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login_required
    redirect_to login_path unless current_user
  end
end
