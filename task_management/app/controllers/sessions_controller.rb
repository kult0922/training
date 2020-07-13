class SessionsController < ApplicationController
  skip_before_action :login_required

  def new
  end

  def create
    user = User.find_by(mail_address: session_params[:mail_address])
    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: I18n.t('sessions.flash.create')
    else
      flash.now[:notice] = I18n.t('sessions.flash.failed_create')
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: I18n.t('sessions.flash.destroy')
  end

  private

  def session_params
    params.require(:session).permit(:mail_address, :password)
  end
end
