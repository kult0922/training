class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_admin

  def index
    @users = User.includes(:tasks).all.page(params[:page])
  end

  def show
    @tasks = @user.tasks.order(created_at: :desc).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: I18n.t('users.flash.create')
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: I18n.t('users.flash.update')
    else
      render :edit
    end
  end

  def destroy
    if last_admin_user
      redirect_to admin_users_path, notice: I18n.t('users.flash.last_admin_user')
      return
    end

    redirect_to admin_users_path, notice: I18n.t('users.flash.destroy') if @user.destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :mail_address, :role, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_admin
    redirect_to root_path unless current_user.admin?
  end

  def last_admin_user
    @user.admin? && User.where(role: :admin).size == 1
  end
end
