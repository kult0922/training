module Admin::Sessions
  extend ActiveSupport::Concern

  included do
    before_action :authorize
    helper_method :current_admin, :logged_in?
  end

  def current_admin
    @current_admin ||= User.find(session[:admin_id]) if session[:admin_id]
  end

  def logged_in?
    current_admin
  end

  def authorize
    unless current_admin
      redirect_to new_admin_sessions_path, alert: t('sessions.flash.not_authrize')
    end
  end
end
