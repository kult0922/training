class UsersController < ApplicationController
  before_action :require_login, except: %i[new create]
  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      flash[:success] = t '.flash.success'
      redirect_to login_path
    else
      flash.now[:danger] = t '.flash.danger'
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end
