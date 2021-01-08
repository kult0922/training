# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    attr_reader :login_user, :users, :user, :authority, :task

    before_action :set_authority, only: %i[new create]

    # TODO: テスト用ユーザー。ステップ19でログインユーザーに変更する
    TEST_USER_ID = 1

    def index
      # TODO: @current_user = current_user ステップ19用
      @login_user = User.select(:login_id, :name, :authority_id).find(TEST_USER_ID) if TEST_USER_ID
      @users = User.select(:id, :login_id, :password, :name, :authority_id)
                   .includes(:authority).page(params[:page])
    end

    def show
      @user = User.find(params[:id])
    end

    def new
      @user = User.new
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
