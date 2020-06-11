class Admin::SessionsController < Admin::Base
  skip_before_action :authorize

  def new
    if current_admin
      redirect_to admin_users_path
    end
  end

  def create
    admin = User.find_by(email: params[:email], is_admin: true)
    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_users_path, notice: t('sessions.flash.create')
    else
      redirect_to new_admin_sessions_path, alert: t('sessions.flash.create_fail')
    end
  end

  def destroy
    session[:admin_id] = nil
    redirect_to new_admin_sessions_path, alert: t('sessions.flash.destroy')
  end
end
