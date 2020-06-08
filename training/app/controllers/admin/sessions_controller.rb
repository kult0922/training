class Admin::SessionsController < Admin::Base
  skip_before_action :authorize

  def new
    if current_user
      redirect_to admin_users_path
    end
  end

  def create
    user = User.find_by(email: params[:email], is_admin: true)
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_users_path, notice: t('sessions.flash.create')
    else
      redirect_to new_admin_sessions_path, alert: t('sessions.flash.create_fail')
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_admin_sessions_path, alert: t('sessions.flash.destroy')
  end
end
