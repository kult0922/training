# frozen_string_literal: true

class Admins::UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admins_user_path(@user), success: 'ユーザーが登録されました'
    else
      flash.now[:danger] = 'ユーザーの登録に失敗しました'
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admins_user_path(@user), success: 'ユーザー情報を編集しました'
    else
      flash.now[:danger] = 'ユーザー情報の編集に失敗しました'
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to admins_users_path, success: 'ユーザーを削除しました'
    else
      redirect_to admins_users_path, danger: 'ユーザーを削除できませんでした'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue StandardError => e
    redirect_to admins_users_path, danger: '存在しないユーザーです'
  end

  def user_params
    params.require(:user).permit(:last_name, :first_name, :email, :password, :password_confirmation)
  end
end
