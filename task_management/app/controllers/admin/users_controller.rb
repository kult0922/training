# frozen_string_literal: true

# アドミンユーザモジュール
module Admin
  # アドミンユーザコントローラ
  class UsersController < ApplicationController
    attr_reader :login_user, :users, :user, :authority, :tasks

    before_action :set_login_user, only: :index
    before_action :set_authority
    before_action :check_login_admin_user

    def index
      @users = User.select(:id, :login_id, :password, :name, :authority_id)
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
        flash[:notice] = '登録が完了しました。'
        redirect_to action: :new
      else
        flash.now[:alert] = '登録に失敗しました。'
        render :new
      end
    end

    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        flash[:notice] = '更新が完了しました。'
        redirect_to action: :edit
      else
        flash.now[:alert] = '更新に失敗しました。'
        render :edit
      end
    end

    def destroy
      delete_user = User.find_by(id: params[:id])
      if delete_login_user?(delete_user)
        flash[:alert] = 'ログイン中のユーザは削除できません。'
        return redirect_to admin_users_url
      end
      if last_admin_user?(delete_user)
        flash[:alert] = '管理ユーザは最低1人必要です。'
        return redirect_to admin_users_url
      end

      User.find(delete_user.id).destroy
      flash[:notice] = '削除しました。'
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

    def set_login_user
      @login_user = current_user
    end

    def check_login_admin_user
      redirect_to login_path unless logged_in? || admin_user?(current_user)
    end

    def delete_login_user?(user)
      login_user = current_user
      login_user.id == user.id
    end

    def last_admin_user?(user)
      # 対象ユーザが管理者以外の場合：false
      return false unless admin_user?(user)

      # 管理者が一人しかいない場合：true
      admin_role_id = Authority.select(:id)
                               .find_by(role: Settings.authority[:admin])
      User.where(authority_id: admin_role_id).count == 1
    end
  end
end
