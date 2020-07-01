module Admin
  class UsersController < ApplicationController
    before_action :check_admin_user
    before_action :find_admin_user, only: %i[show edit update destroy]
    before_action :find_admin_user_role, only: %i[new create edit update]
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
        flash[:success] = t '.flash.success', action: t('.sakusei')
        redirect_to admin_users_path
      else
        flash.now[:danger] = t '.flash.danger', action: t('.sakusei')
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
        flash[:success] = t '.flash.success', action: t('.koushin')
        redirect_to admin_user_path
      else
        flash.now[:danger] = t '.flash.danger', action: t('.koushin')
        render :edit
      end
    end

    def destroy
      if @admin_user.destroy
        flash[:success] = t '.flash.success', action: t('.sakuzyo')
      else
        flash[:danger] = t '.flash.danger', action: t('.sakuzyo')
      end
      redirect_to admin_users_path
    end

    private

    def admin_user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end

    def find_admin_user
      @admin_user = User.find(params[:id])
    end

    def find_admin_user_role
      @admin_user_roles = User.roles.map { |k, _| [User.human_attribute_enum_val(:role, k), k] }.to_h
    end

    def check_admin_user
      redirect_to tasks_path unless current_user.admin?
    end
  end
end
