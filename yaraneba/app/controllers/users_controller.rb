# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :redirect_logged_in_user

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if User.find_by(email: @user.email, deleted_at: nil).present?
      redirect_to users_path, flash: { alert: I18n.t('notice.fault') }
    else
      @user.save
      session[:user_id] = @user.id
      redirect_to tasks_path, flash: { notice: I18n.t('notice.success') }
    end
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
