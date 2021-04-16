class SessionsController < ApplicationController
  before_action :require_login, except: [:new, :create, :log_in, :destroy]

  def new
    render :new
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    if user && (BCrypt::Password.new(user.password_digest) == params[:password])
      log_in(user)
      redirect_to root_path
    else
      flash.now.notice = I18n.t('error.message.login_fail')
      @user = User.new
      render :new
    end
  end
  
  def destroy
    log_out
    flash.notice = I18n.t('flash.logout')
    redirect_to login_path
  end
end
