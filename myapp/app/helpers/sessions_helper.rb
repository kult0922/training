module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def current_user?(user)
    logged_in? ? current_user.id == user.id : false
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    session.delete(:user_id)
    current_user = nil if logged_in?
  end

end
