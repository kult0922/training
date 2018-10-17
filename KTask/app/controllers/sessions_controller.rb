class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to index_url, notice: t('flash.session.login_success')
    else
      flash.now[:danger] = t('flash.session.login_failed')
      render 'new'
    end
  end

  def destroy
  end

end
