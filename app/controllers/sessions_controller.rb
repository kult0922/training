class SessionsController < ApplicationController
  skip_before_action :require_sign_in!, only: %i[new create]

  def new
  end

  def create
    user = User.find_by(user_name: params[:session][:user_name])

    if !user.nil? && user.authenticate(params[:session][:password])
      log_in(user)
      redirect_to root_path
    else
      render action: :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end
end
