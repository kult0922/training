# frozen_string_literal: true

# アドミンユーザーモジュール
module Admin
  # アドミンユーザーコントローラ
  class UsersController < ApplicationController
    attr_reader :login_user, :users, :user, :authority, :tasks

    before_action :set_authority, only: %i[new edit create update]

    # TODO: テスト用ユーザー。ステップ19でログインユーザーに変更する
    TEST_USER_ID = 1

    def index
      # TODO: @current_user = current_user ステップ19用
      @login_user = User.select(:login_id, :name, :authority_id)
                        .find(TEST_USER_ID)
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
      User.find(params[:id]).destroy
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
  end
end
