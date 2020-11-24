class ApplicationController < ActionController::Base
  # rescue_from Exception, with: :render_500
  # rescue_from ActiveRecord::RecordNotFound, with: :render_404
  # rescue_from ActionController::RoutingError, with: :render_404

  helper_method :current_user, :logged_in?

  def routing_error
    raise ActionController::RoutingError, params[:path]
  end

  def render_404
    render 'errors/404', status: :not_found
  end

  def render_500
    render 'errors/500', status: :internal_server_error
  end

  private

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def logged_in_user
    redirect_to login_url unless logged_in?
  end
end
