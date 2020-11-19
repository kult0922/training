class ApplicationController < ActionController::Base
  include SessionsHelper

  rescue_from Exception, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404

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

  def logged_in_user
    redirect_to login_url unless logged_in?
  end
end
