# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    attr_reader :task, :user, :users

    # TODO: テスト用ユーザー。ステップ19でログインユーザーに変更する
    TEST_USER_ID = 1

    def index
      # user_id = session[:user_id]
      @user = User.select(:login_id, :name, :authority_id).find(TEST_USER_ID) if TEST_USER_ID
      @users = User.select(:id, :login_id, :password, :name, :authority_id).includes(:authority)
    end
  end
end
