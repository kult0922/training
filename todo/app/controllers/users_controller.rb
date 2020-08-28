# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :logged_in_user, only: :edit

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = I18n.t('flash.succeeded', model: 'ユーザ', action: '作成')
      redirect_to login_path
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'ユーザ', action: '作成')
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = I18n.t('flash.succeeded', model: 'ユーザ', action: '更新')
      redirect_to projects_path
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'ユーザ', action: '更新')
      render :edit
    end
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:account_name, :password, :password_confirmation)
  end
end
