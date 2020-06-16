module Admin
  class UsersController < ApplicationController
    include SessionsHelper
    before_action :check_admin_user
    before_action :set_admin_user_role, only: %i[new create edit update]
    before_action :require_login
    PAGE_PER = 5
    def index
      @admin_users = Admin::User.all.page(params[:page]).per(PAGE_PER)
    end

    def new
      @admin_user = Admin::User.new
    end

    def create
      @admin_user = Admin::User.create(admin_user_params)
      if @admin_user.save
        flash[:success] = t '.flash.success', action: :作成
        redirect_to admin_users_path
      else
        flash.now[:danger] = t '.flash.danger', action: :作成
        render :new
      end
    end

    def show
      @admin_user = Admin::User.find(params[:id])
      @tasks = @admin_user.tasks
    end

    def edit
      @admin_user = Admin::User.find(params[:id])
    end

    def update
      @admin_user = Admin::User.find(params[:id])
      if @admin_user.update(admin_user_params)
        flash[:success] = t '.flash.success', action: :更新
        redirect_to admin_user_path
      else
        flash.now[:danger] = t '.flash.danger', action: :更新
        render :edit
      end
    end

    def destroy
      @admin_user = Admin::User.find(params[:id])
      valid_user_role
      if @admin_user.present? && @admin_user.destroy
        flash[:success] = t '.flash.success', action: :削除
      else
        flash[:danger] = t '.flash.danger', action: :削除
      end
      redirect_to admin_users_path
    end

    private

    def admin_user_params
      params.require(:admin_user).permit(:name, :email, :password, :password_confirmatin, :role)
    end

    def set_admin_user_role
      @admin_user_roles = Admin::User.roles.map { |k, _| [Admin::User.human_attribute_enum_val(:role, k), k] }.to_h
    end

    def valid_user_role
      @admin_user = nil if @admin_user.admin? && Admin::User.where(role: 1).size < 2
    end

    def check_admin_user
      redirect_to tasks_path unless current_user.admin?
    end
  end
end
