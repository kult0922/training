class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :roles_all, only: [:new, :edit]
  before_action :only_admin
  before_action :logged_in_user
  PER = 20

  def index
    @users = User.includes(:tasks).includes(:role).all.page(params[:page]).per(PER)
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
      roles_all
      render :new
    end
  end

  def edit; end

  def update
    if only_one_admin? && params[:role_id] == 2
      flash.now[:danger] = '管理ユーザーが一人なので変更できません。'
      roles_all
      render :edit
    elsif @user.update(user_params)
      flash[:success] = I18n.t('flash.model.succeeded', target: 'ユーザー', action: '更新')
      redirect_to users_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: 'ユーザー', action: '更新')
      roles_all
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

  def roles_all
    @roles = Role.all
  end

  def only_one_admin?
    User.eager_load(:role).where(roles: { name: '管理ユーザー' }).size == 1 && @user.role.name == '管理ユーザー'
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :role_id, auth_info_attributes: [:email, :password, :password_confirmation])
  end
end
