class SessionsController < ApplicationController
  def new
    redirect_to root_url if logged_in?
  end

  def create
    auth = AuthInfo.find_by(email: params[:session][:email].downcase)
    if auth&.authenticate(params[:session][:password])
      log_in auth.user
      redirect_to root_url
      flash[:success] = I18n.t('flash.session.succeeded', action: I18n.t( 'login'))
    else
      flash.now[:danger] = I18n.t('flash.session.failed', action: I18n.t( 'login'))
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    if redirect_to root_url
      flash[:success] = I18n.t('flash.session.succeeded', action: I18n.t( 'logout'))
    end
  end
end
