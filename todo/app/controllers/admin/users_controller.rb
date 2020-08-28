class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :logged_in_user
  before_action :admin_user
  before_action :current_user

  def index
    @users = User.all.page(params[:page]).per(20)
  end

  def show
    @tasks = load_task
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

  def set_user
    @user = User.find(params[:id])
  end

  def admin_user
    redirect_to projects_path unless @current_user.admin?
  end

  private

  def load_task
    Task.eager_load(:assignee, :reporter)
      .where('assignee_id = ? OR reporter_id = ? ', params[:id], params[:id])
      .page(params[:page]).per(20)
  end

  def user_params
    params.require(:user).permit(:account_name, :password, :password_confirmation)
  end
end
