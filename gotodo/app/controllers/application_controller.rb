# frozen_string_literal: true

class ApplicationController < ActionController::Base
  add_flash_types :success, :info, :warning, :danger

  before_action :render_503, if: :maintenance_mode?
  def render_503
    render file: Rails.public_path.join('503.ja.html'), status: 503
  end

  def maintenance_mode?
    File.exist?(Constants::MAINTENANCE)
  end

  before_action :login_check
  def login_check
    redirect_to login_path unless current_user
  end

  helper_method :current_user
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def admin_check
    redirect_to login_path unless admin?
  end

  helper_method :admin?
  def admin?
    @current_user.role.name == 'admin' if @current_user.role
  end
end
