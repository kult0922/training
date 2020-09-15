# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in(user)
      redirect_to root_path
    else
      flash.now[:notice] = 'Email、またはPasswordが間違っています。'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to login_path
  end
end
