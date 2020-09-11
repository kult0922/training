class ApplicationController < ActionController::Base
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from StandardError, with: :render_500
  helper_method :current_user, :logged_in?

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def render_404
    logger.debug('404')
    render template: 'errors/error_404', status: 404, layout: 'application', content_type: 'text/html'
  end

  def render_500
    logger.debug('500')
    render template: 'errors/error_500', status: 500, layout: 'application', content_type: 'text/html'
  end
end
