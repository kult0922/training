module SessionHundle
  extend ActiveSupport::Concern

  included do
    helper_method :logged_in?, :current_user, :owner?

    def log_in(user)
      session[:user_id] = user.id
    end

    def current_user?(user)
      user == current_user
    end

    def log_out
      session.delete(:user_id)
      @current_user = nil
    end

    def logged_in_user
      redirect_to login_url unless logged_in?
    end

    def not_permit(msg)
      redirect_to root_url, flash: { danger: I18n.t(msg) }
    end

    def only_admin
      not_permit('flash.admin.permit') unless current_user.administrator?
    end
  end

  def logged_in?
    current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def owner?(model)
    model.user == current_user
  end
end
