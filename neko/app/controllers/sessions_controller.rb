class SessionsController < ApplicationController
  def new
    redirect_to root_url if logged_in?
  end

  def create
    auth = AuthInfo.find_by(email: params[:session][:email].downcase)
    if auth && auth.authenticate(params[:session][:password])
      log_in auth.user
      redirect_to root_url
    else
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
