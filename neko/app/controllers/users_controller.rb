class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user
  PER = 20

  def index
    @users = User.includes(:tasks).all.page(params[:page]).per(PER)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.user = @current_user

    if @user.save
      flash[:success] = I18n.t('flash.model.succeeded', target: 'ユーザー', action: '作成')
      redirect_to users_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: 'ユーザー', action: '作成')
      statuses_all
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = I18n.t('flash.model.succeeded', target: 'ユーザー', action: '更新')
      redirect_to users_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: 'ユーザー', action: '更新')
      statuses_all
      render :edit
    end
  end

  def destroy
    auth = AuthInfo.find_by(user: @user)
    if auth.destroy
      flash[:success] = I18n.t('flash.model.succeeded', target: 'ユーザー', action: '削除')
      log_out
      redirect_to users_path
    else
      flash.now[:danger] = I18n.t('flash.model.failed', target: 'ユーザー', action: '削除')
      render :index
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name)
  end
end
