class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :logged_in_user
  before_action :only_admin

  def index
    @users = User.includes(:tasks).all.page(params[:page])
  end

  def new
    @user = User.new
    @user.build_auth_info
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = I18n.t('flash.model.succeeded', target: @user.model_name.human, action: I18n.t(action_name))
      redirect_to users_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: @user.model_name.human, action: I18n.t(action_name))
      render :new
    end
  end

  def edit; end

  def update
    exit(1)
    if only_one_admin? && params[:user][:role] == User.roles.keys.first
      flash.now[:danger] = I18n.t('flash.admin.only_one_admin', action: I18n.t(action_name))
      render :edit
    elsif @user.update(user_params)
      flash[:success] = I18n.t('flash.model.succeeded', target: @user.model_name.human, action: I18n.t(action_name))
      redirect_to users_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: @user.model_name.human, action: I18n.t(action_name))
      render :edit
    end
  end

  def destroy
    if only_one_admin?
      flash.now[:danger] = I18n.t('flash.admin.only_one_admin', action: I18n.t(action_name))
      redirect_to users_path
    elsif @user.destroy
      flash[:success] = I18n.t('flash.model.succeeded', target: @user.model_name.human, action: I18n.t(action_name))
      log_out if @user == current_user
      redirect_to users_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: @user.model_name.human, action: I18n.t(action_name))
      render :index
    end
  end

  private

  def only_one_admin?
    User.where(role: 0).size == 1 && @user.role == User.roles.keys.first
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :role, auth_info_attributes: [:email, :password, :password_confirmation])
  end
end
