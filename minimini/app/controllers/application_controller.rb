class ApplicationController < ActionController::Base
  protect_from_forgery

  before_action :render_503, if: :is_maintenance_mode?

  helper_method :current_user, :is_logged_in?

  rescue_from StandardError, with: :render_500
  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render file: Rails.root.join('public/404.html'), status: 404, layout: false, content_type: 'text/html'
  end

  def render_500
    render file: Rails.root.join('public/404.html'), status: 500, layout: false, content_type: 'text/html'
  end

  def render_503
    render file: Rails.root.join('public/503.html'), status: 503, layout: false, content_type: 'text/html'
  end

  def is_maintenance_mode?
    # DBあり、DBなしメンテナンス
    File.exist?('tmp/maintenance.txt') || MaintenanceSchedule.has_scheduled_maintenance?
  end

  private
    def require_login
      redirect_to login_path unless is_logged_in?
    end

    def is_logged_in?
      !session[:current_user_id].nil?
    end

    def log_in(user)
      session[:current_user_id] = user.id
    end

    def log_out
      session.delete(:current_user_id)
      @_current_user = nil
    end

    def current_user
      @_current_user ||= session[:current_user_id] &&
      User.find_by(id: session[:current_user_id])
    end
end
