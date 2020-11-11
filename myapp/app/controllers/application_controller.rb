require 'bcrypt'

class ApplicationController < ActionController::Base
  before_action :basic_auth
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from Exception, with: :render_500

  def render_404
    render status: 404, template: 'errors/404', :locals => { :message => 'Page Not Found' }
  end

  def render_500
    render status: 500, template: 'errors/500', :locals => { :message => 'Internal Server Error' }
  end

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      @me = User.find_by(name: username)
      @me.present? && BCrypt::Password.new(@me.encrypted_password) == password
    end
  end

end
