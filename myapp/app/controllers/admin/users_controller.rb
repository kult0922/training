module Admin
  class UsersController < ApplicationController

    def index
      @admin_users = Admin::User.all
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
      if @admin_user.destroy
        flash[:success] = t '.flash.success', action: :削除
      else
        flash.now[:danger] = t '.flash.danger', action: :削除
      end
      redirect_to admin_users_path
    end

    private

    def admin_user_params
      params.require(:admin_user).permit(:name, :email, :password, :password_confirmatin, :role)
    end

  end
end
