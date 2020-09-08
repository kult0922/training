class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_path
    else
      flash.now[:danger] = t('dictionary.message.invalid_email_or_password')
      render 'new'
    end
  end

  def destroy
  end
end
