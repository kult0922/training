class SessionsController < ApplicationController
  def new
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def create
    user = User.find_by(account_name: params[:session][:account_name])
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to projects_url
    else
      render 'new'
    end
  end

  def fail
  end
end
