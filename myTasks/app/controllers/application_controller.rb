class ApplicationController < ActionController::Base
  if !Rails.env.development?
    rescue_from StandardError,                    with: :render_500
    rescue_from ActiveRecord::RecordNotFound,     with: :render_404
    rescue_from ActionController::RoutingError,   with: :render_404
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_404(e = nil)
    logger.info "Rendering 404 with exception: #{e.message}" if e
    format = params[:format] == :json ? :json : :html
    render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
  end

  def render_500(e = nil)
    logger.info "Rendering 500 with exception: #{e.message}" if e 
    format = params[:format] == :json ? :json : :html
    render file: Rails.root.join('public/500.html'), status: 500, layout: false, content_type: 'text/html'
  end
end
