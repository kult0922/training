# frozen_string_literal: true

class Admins::UsersController < ApplicationController
  before_action :user_initialize, only: %i[show edit update destroy]
  before_action :admin_user_initialize
  before_action :logged_in_admin_user

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show; end

  def new
    @user = User.new
    @roles = Role.all
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admins_user_path(@user), success: I18n.t('flash.create_user')
    else
      flash.now[:danger] = I18n.t('flash.create_user_failed')
      render :new
    end
  end

  def edit
    @roles = Role.all
  end

  def update
    if @user.update(user_params)
      redirect_to admins_user_path(@user), success: I18n.t('flash.update_user')
    else
      flash.now[:danger] = I18n.t('flash.update_user_failed')
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admins_users_path, success: I18n.t('flash.destroy_user')
    else
      redirect_to admins_users_path, danger: I18n.t('flash.destroy_user_failed')
    end
  end

  private

  def user_params
    params.require(:user).permit(:last_name, :first_name, :email, :password, :password_confirmation,
                                  role_ids: [])
  end
end
