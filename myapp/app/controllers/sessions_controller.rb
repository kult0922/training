class SessionsController < ApplicationController
  before_action :find_user, only: [:create]
  def new
  end

  def create
    if @user.authenticate(session_params[:password])
      log_in(@user)
      remember(@user)
      flash[:success] = t '.flash.sesson_success'
      redirect_to tasks_path
    else
      flash.now[:danger] = t '.flash.sesson_danger'
      render :new
    end
  end

  def destroy
    logout if logged_in?
    flash[:success] = t '.flash.logout_success'
    redirect_to login_path
  end

  private

  def session_params
    params.require(:session).permit(:email, :password)
  end

  def find_user
    @user = User.find_by(email: params[:session][:email])
    if @user.blank?
      flash.now[:danger] = t '.flash.mail_danger'
      render :new
    end
  end
end
