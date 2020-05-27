class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :only_admin
  before_action :logged_in_user
  PER = 20

  def index
    @users = User.includes(:tasks).all.page(params[:page]).per(PER)
  end

  def new
    @user = User.new
    @user.build_auth_info
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = I18n.t('flash.model.succeeded', target: 'ユーザー', action: '作成')
      redirect_to users_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: 'ユーザー', action: '作成')
      render :new
    end
  end

  def edit; end

  def update
    if only_one_admin? && params[:role_id] == 2
      flash.now[:danger] = '管理ユーザーが一人なので変更できません。'
      render :edit
    elsif @user.update(user_params)
      flash[:success] = I18n.t('flash.model.succeeded', target: 'ユーザー', action: '更新')
      redirect_to users_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: 'ユーザー', action: '更新')
      render :edit
    end
  end

  def destroy
    if only_one_admin?
      flash[:danger] = '管理ユーザーが一人なので削除できません。'
      redirect_to users_path
    elsif @user.destroy
      flash[:success] = I18n.t('flash.model.succeeded', target: 'ユーザー', action: '削除')
      log_out if @user == @current_user
      redirect_to users_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: 'ユーザー', action: '削除')
      render :index
    end
  end

  private

  def only_one_admin?
    User.where(roles: 0).size == 1 && @user.role == 0
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :role, auth_info_attributes: [:email, :password, :password_confirmation])
  end
end
