module Admin
  class UsersController < ApplicationController
    before_action :set_admin_user, only: %i[show edit update destroy]
    before_action :set_admin_user_role, only: %i[new create edit update]
    before_action :require_login
    PAGE_PER = 5
    def index
      @admin_users = User.all.page(params[:page]).per(PAGE_PER)
    end

    def new
      @admin_user = User.new
    end

    def create
      @admin_user = User.new(admin_user_params)
      if @admin_user.save
        flash[:success] = t '.flash.success', action: :作成
        redirect_to admin_users_path
      else
        flash.now[:danger] = t '.flash.danger', action: :作成
        render :new
      end
    end

    def show
      @tasks = @admin_user.tasks
    end

    def edit
    end

    def update
      if @admin_user.update(admin_user_params)
        flash[:success] = t '.flash.success', action: :更新
        redirect_to admin_user_path
      else
        flash.now[:danger] = t '.flash.danger', action: :更新
        render :edit
      end
    end

    def destroy
      if @admin_user.destroy
        flash[:success] = t '.flash.success', action: :削除
      else
        flash.now[:danger] = t '.flash.danger', action: :削除
      end
      redirect_to admin_users_path
    end

    private

    def admin_user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end

    def set_admin_user
      @admin_user = User.find(params[:id])
    end

    def set_admin_user_role
      @admin_user_roles = User.roles.map { |k, _| [User.human_attribute_enum_val(:role, k), k] }.to_h
    end
  end
end
