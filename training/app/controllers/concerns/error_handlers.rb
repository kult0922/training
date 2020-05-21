module ErrorHandlers
  extend ActiveSupport::Concern

  included do
    class Forbidden < ActionController::ActionControllerError; end
    # rescue_from Exception, with: :rescue500
    rescue_from Forbidden, with: :rescue403
  end

  private

  def rescue403
    render 'errors/forbidden', status: 403
  end

  def rescue500
    render 'errors/internal_server_error', status: 500
  end
end
