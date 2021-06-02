# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :login

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_session_path, notice: t('message.user.create.succeeded')
    else
      flash.now[:alert] = t('message.user.create.failed')
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end