# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  before_action :redirect_logged_in_user
  before_action :redirect_if_administrator_is_required, only: %i[update destroy]

  def new
    @user = User.new
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: I18n.t('notice.success')
    else
      redirect_to admin_users_path, alert: I18n.t('notice.fault')
    end
  end

  def create
    @user = User.new(user_params)
    if User.find_by(email: @user.email, deleted_at: nil).present?
      redirect_to new_user_path, alert: I18n.t('notice.fault')
    else
      @user.save
      save_user_info_to_session
      redirect_to tasks_path, notice: I18n.t('notice.success')
    end
  end

  def destroy
    if @user.id != session[:id] && @user.destroy
      redirect_to admin_users_path, notice: I18n.t('notice.success')
    else
      redirect_to admin_users_path, notice: I18n.t('notice.fault')
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params['user']['role_id'] ||= Role::ROLE_MEMBER
    params.require(:user).permit(:email, :password, :role_id)
  end
end
