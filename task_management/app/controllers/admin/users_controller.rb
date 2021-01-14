# frozen_string_literal: true

# アドミンユーザーモジュール
module Admin
  # アドミンユーザーコントローラ
  class UsersController < ApplicationController
    attr_reader :login_user, :users, :user, :authority, :tasks

    before_action :set_login_user, only: :index
    before_action :set_authority
    before_action :check_login_user

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
      delete_user_id = params[:id]
      if delete_login_user?(delete_user_id)
        flash[:alert] = 'ログイン中のユーザは削除できません。'
        return redirect_to admin_users_url
      end
      if delete_last_admin_user?(delete_user_id)
        flash[:alert] = '管理ユーザは最低1人必要です。'
        return redirect_to admin_users_url
      end

      User.find(delete_user_id).destroy
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

    def delete_login_user?(user_id)
      login_user = current_user
      login_user.id.to_s == user_id.to_s
    end

    def delete_last_admin_user?(user_id)
      # 削除対象のユーザが管理者ではない場合：false
      target_user = User.select(:authority_id)
                        .find_by(id: user_id)
      target_user_auth = Authority.select(:role)
                                  .find_by(id: target_user.authority_id)
      return false if Settings.authority[:admin] != target_user_auth.role

      # 削除対象のユーザが最後1人の管理者の場合：true
      admin_role_id = Authority.select(:id)
                               .find_by(role: Settings.authority[:admin])
      admin_user_cnt = User.where(authority_id: admin_role_id).count
      admin_user_cnt == 1
    end
  end
end
