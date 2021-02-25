# frozen_string_literal: true

# アドミンユーザーモジュール
module Admin
  # アドミンユーザーコントローラ
  class UsersController < ApplicationController
    before_action :check_login_user
    before_action :check_admin_user
    before_action :set_authority, except: %i[show destroy]

    def index
      @users = User.select(:id, :login_id, :password_digest, :name, :authority_id)
                   .includes(:authority)
                   .page(params[:page])
                   .order(:authority_id).order(:id)
    end

    def show
      @tasks = Task.where(user_id: params[:id])
                   .order('creation_date DESC')
                   .page(params[:page])
    end

    def new
      @user = User.new
    end

    # 編集画面
    # GET /tasks/[:タスクテーブルID]/edit
    def edit
      @user = User.find(params[:id])
    end

    def create
      @user = User.new(user_params)
      if @user.save
        flash[:notice] = I18n.t('flash.success.create',
                                name: I18n.t('admin.users.header.login_id'),
                                value: @user.login_id)
        redirect_to action: :new
      else
        render :new
      end
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        flash[:notice] = I18n.t('flash.success.update',
                                name: I18n.t('admin.users.header.login_id'),
                                value: @user.login_id)
        redirect_to action: :edit
      else
        render :edit
      end
    end

    def destroy
      delete_user = User.find_by(id: params[:id])
      if delete_user == current_user
        flash[:alert] = I18n.t('admin.users.flash.error.delete.login_user',
                               name: I18n.t('admin.users.header.login_id'),
                               value: delete_user.login_id)
        return redirect_to admin_users_url
      end

      delete_user.destroy
      flash[:notice] = I18n.t('flash.success.delete',
                              name: I18n.t('admin.users.header.login_id'),
                              value: delete_user.login_id)
      redirect_to admin_users_url
    end

    private

    def user_params
      params.require(:user).permit(:login_id,
                                   :password,
                                   :name,
                                   :authority_id)
    end

    def set_authority
      @authority = Authority.all
    end

    def check_admin_user
      render_404 unless current_user.admin_user?
    end
  end
end
