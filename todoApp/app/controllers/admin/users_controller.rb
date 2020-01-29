class Admin::UsersController < ApplicationController
  before_action :authorize
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  access admin: :all, message: I18n.t('permission_denied')

  def index
    @users = User.all.page(params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id unless session[:user_id]
      redirect_to root_path, notice: I18n.t('flash_message.signup_complete')
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: I18n.t('flash_message.user_update_complete')
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      session[:user_id] = nil if @user.id == session[:user_id]
      redirect_to admin_users_path, notice: I18n.t('flash_message.user_delete_success')
    else
      redirect_to admin_users_path, notice: @user.errors[:base].first ||= I18n.t('flash_message.delete_fail')
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
  end
end