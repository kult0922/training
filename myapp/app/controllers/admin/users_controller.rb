class Admin::UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all.order(created_at: :desc, id: :desc)
  end

  def show; end

  def new; end
  def create; end

  def update
    if @user.update(user_params)
      redirect_to admin_user_url(@user), notice: I18n.t('notice_updated')
    else
      render :show
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_url, notice: I18n.t('notice_deleted')
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render status: :not_found, template: 'errors/404', locals: { message: I18n.t('admin.users.not_found') }
  end

  def user_params
    params.fetch(:user, {}).permit(:name, :email)
  end

end
