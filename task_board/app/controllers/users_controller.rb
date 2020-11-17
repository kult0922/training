class UsersController < ApplicationController
  def new
    redirect_to root_url if logged_in?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      log_in @user
      redirect_to root_url, notice: I18n.t('signup.message.success')
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
