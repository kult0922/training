module Admin
  class UsersController < ApplicationController
    before_action :check_admin_role
    before_action :set_user, only: %i[show edit update destroy edit_password]

    def index
      @users = User.all.page(params[:page])
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_users_url, notice: t('admin.flash.create', name: @user.name)
      else
        render :new
      end
    end

    def show
      @tasks = @user.tasks.order(created_at: :desc)
    end

    def edit; end

    def edit_password; end

    def update
      if @user.update(user_params)
        redirect_to admin_users_url, notice: t('admin.flash.update', name: @user.name)
      else
        render :edit
      end
    end

    def destroy
      if current_user == @user
        redirect_to admin_users_url, alert: t('admin.flash.delete.error')
      elsif last_admin?
        redirect_to admin_users_url, notice: '他に管理者ユーザーが無いため削除できません。'
      end
      @user.destroy
      redirect_to admin_users_url, notice: t('admin.flash.delete.success', name: @user.name)
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def check_admin_role
      redirect_to login_url unless current_user&.admin?
    end

    def last_admin?
      @user.admin? && User.where(role: :admin).size == 1
    end
  end
end
