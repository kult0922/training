# frozen_string_literal: true

class ApplicationController < ActionController::Base
  class Forbidden < ActionController::ActionControllerError; end

  rescue_from StandardError, with: :rescue500
  rescue_from Forbidden, with: :rescue403
  rescue_from ActiveRecord::RecordNotFound, with: :rescue404

  private def rescue500()
    render 'errors/internal_server_error', status: 500
  end

  private def rescue403()
    render 'errors/forbidden', status: 403
  end

  private def rescue404()
    render 'errors/not_found', status: 404
  end
end
