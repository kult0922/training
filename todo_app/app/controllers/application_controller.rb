class ApplicationController < ActionController::Base

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  def render_404
      render template: 'errors/not_found', status: :not_found
  end
      
  def render_500
    render template: 'errors/internal_server_error', status: :internal_server_error
  end
end
