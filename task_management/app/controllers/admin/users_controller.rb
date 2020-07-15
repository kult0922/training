class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

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
    @user.destroy if redirect_to admin_users_path, notice: I18n.t('users.flash.destroy')
  end

  private

  def user_params
    params.require(:user).permit(:name, :mail_address, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
