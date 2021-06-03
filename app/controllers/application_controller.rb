# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login
  before_action :render_maintenance_page, if: :maintenance_mode?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def login
    redirect_to new_session_path unless current_user
  end

  def maintenance_mode?
    File.exist?(Rails.root.join(MAINTENANCE_FILE_NAME))
  end

  def render_maintenance_page
    render file: Rails.root.join('public/503.html'), status: 503, layout: false, content_type: 'text/html'
  end
end
