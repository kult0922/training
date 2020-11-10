require 'bcrypt'

class ApplicationController < ActionController::Base
  before_action :basic_auth
  protect_from_forgery with: :exception

  private

  def basic_auth
    authenticate_or_request_with_http_basic do |username, password|
      @me = User.find_by(name: username)
      @me.present? && BCrypt::Password.new(@me.encrypted_password) == password
    end
  end

end
