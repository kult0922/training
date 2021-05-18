module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from Exception, with: :rescue500
    rescue_from ApplicationController::Forbidden, with: :rescue403
    rescue_from ApplicationController::IpAddressRejected, with: :rescue403
    rescue_from ActionController::RoutingError, with: :rescue404
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404
  end

  private

  def rescue403(error)
    @exception = error
    render 'errors/403', status: :forbidden
  end

  def rescue404(error)
    @exception = error
    render 'errors/404', status: :not_found
  end

  def rescue500(error)
    @exception = error
    render '/errors/500', status: :internal_server_error
  end
end
