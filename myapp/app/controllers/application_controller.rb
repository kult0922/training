class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :should_log_in

  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :render404
  rescue_from ActionController::RoutingError, with: :render404
  rescue_from Exception, with: :render500

  def render404(e)
    logger.warn e
    render status: :not_found, template: 'errors/404', locals: { message: 'Page Not Found' }
  end

  def render500(e)
    logger.error e
    logger.error e.backtrace.join('\n')
    render status: :internal_server_error, template: 'errors/500', locals: { message: 'Internal Server Error' }
  end

  private

  def should_log_in
    redirect_to login_path unless logged_in?
  end
end
