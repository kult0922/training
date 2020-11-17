class SessionsController < ApplicationController
  def new
    redirect_to root_url if logged_in?
    @user = User.new
  end

  def create
    @user = User.find_by(email: session_params[:email].downcase)
    if @user&.authenticate(session_params[:password])
      log_in @user
      redirect_to root_url
    else
      flash.now[:notice] = I18n.t('login.message.error')
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
