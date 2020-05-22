module ErrorHandlers
  extend ActiveSupport::Concern

  class Forbidden < ActionController::ActionControllerError; end
  class IpAddressRejected < ActionController::ActionControllerError; end

  included do
    rescue_from Exception, with: :rescue500
    rescue_from ActiveRecord::RecordNotFound, with: :rescue404
    rescue_from Forbidden, with: :rescue403
    rescue_from IpAddressRejected, with: :rescue403
  end

  def rescue403
    render 'errors/forbidden', status: 403
  end

  def rescue404
    render 'errors/not_found', status: 404
  end

  def rescue500
    render 'errors/internal_server_error', status: 500
  end
end
