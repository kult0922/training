# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :find_user_by_id, only: %i[show edit update destroy]
  before_action :logged_in_user

  PER = 5

  def index
    @users = User.includes(:tasks).page(params[:page]).per(PER)
  end

  def new
    @user = User.new
  end

  def show
  end

  def edit
  end

  def create
    @user = User.new(permitted_users_params)
    if @user.save
      redirect_to users_path, notice: I18n.t('users.controller.messages.created')
    else
      flash.now[:notice] = I18n.t('users.controller.messages.failed_to_edited')
      render 'new'
    end
  end

  def update
    if @user.update(permitted_users_params)
      redirect_to users_path, notice: I18n.t('users.controller.messages.edited')
    else
      flash.now[:notice] = I18n.t('users.controller.messages.failed_to_edited')
      render 'edit'
    end
  end

  def destroy
    @user.destroy!
    redirect_to users_path, notice: I18n.t('users.controller.messages.deleted')
  end

  private

  def permitted_users_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
    )
  end

  def find_user_by_id
    @user = User.find(params[:id])
  end
end
