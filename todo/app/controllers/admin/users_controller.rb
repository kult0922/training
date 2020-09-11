# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[edit update destroy]
  before_action :logged_in_user
  before_action :admin_only
  before_action :current_user
  before_action :check_delete_own, only: :destroy

  def index
    @users = User.all.page(params[:page])
  end

  def show
    @tasks = Task.eager_load(:assignee, :reporter)
      .user_had_task(params[:id])
      .page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = I18n.t('flash.succeeded', model: 'ユーザ', action: '作成')
      redirect_to admin_users_path
    else
      flash[:error] = I18n.t('flash.failed', model: 'ユーザ', action: '作成')
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = I18n.t('flash.succeeded', model: 'ユーザ', action: '更新')
      redirect_to admin_users_path
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'ユーザ', action: '更新')
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:notice] = I18n.t('flash.succeeded', model: 'ユーザ', action: '削除')
      redirect_to admin_users_path
    else
      flash.now[:error] = I18n.t('flash.failed', model: 'ユーザ', action: '削除')
      render :index
    end
  end

  private

  def check_delete_own
    return if @current_user.account_name != @user.account_name
    flash[:error] = I18n.t('flash.delete_own')
    redirect_to admin_users_path
  end

  def set_user
    @user = User.find(params[:id])
  end

  def admin_user
    return if @current_user.admin?
    render_404
  end

  private

  def user_params
    params.require(:user).permit(:account_name, :password, :password_confirmation, :admin)
  end
end
