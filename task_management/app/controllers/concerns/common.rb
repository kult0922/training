# frozen_string_literal: true

module Common
  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def render_404(exception = nil)
    logger.info "Rendering 404: #{exception.message}" if exception
    render Settings.page_path[:not_found], status: :not_found
  end

  def render_500(exception = nil)
    logger.info "Rendering 500: #{exception.message}" if exception
    render Settings.page_path[:internal_server_error], status: :internal_server_error
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end
end
