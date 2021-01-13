# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:test_authority_admin) do
    create(:authority,
           id: 1,
           role: 0,
           name: '管理者')
  end
  let!(:test_user_A) do
    create(:user,
           id: 1,
           login_id: 'test_user_1',
           authority_id: test_authority_admin.id)
  end

  describe '#index' do
    before { visit admin_users_path }
    context 'トップページにアクセスした場合' do
      example 'ユーザ一覧が表示される' do

      end
    end

    context 'タスク数のリンクを押下した場合' do
      example 'ユーザのタスク一覧が表示される' do

      end
    end

    context 'ユーザ編集ボタンを押下した場合' do
      example 'ユーザ編集画面に遷移する' do

      end
    end

    context 'ユーザ削除ボタンを押下した場合' do
      example '対象ユーザのデータが削除される' do

      end
    end

    context 'ユーザ作成のリンクを押下した場合' do
      example 'ユーザ作成画面に遷移する' do

      end
    end

    context 'ログアウトボタンを押下した場合' do
      example 'ログイン画面に遷移する' do

      end
    end
  end

  describe '#show(user_id)' do
    context '閉じるボタンを押下した場合' do
      example 'ユーザタスク一覧画を閉じる' do

      end
    end
  end

  describe '#edit' do
    context '全項目を入力し、更新ボタンを押下した場合' do
      example 'ユーザを更新できる' do
      end
    end

    context '必須項目を入力せず、更新ボタンを押下した場合' do
      example 'ユーザを更新できない' do
      end
    end

    context '「ユーザ一覧画面へ」のリンクを押下した場合' do
      example 'ユーザ一覧画面へ遷移する' do
      end
    end
  end

  describe '#edit' do
    context '全項目を入力し、更新ボタンを押下した場合' do
      example 'ユーザを更新できる' do
      end
    end

    context '必須項目を入力せず、更新ボタンを押下した場合' do
      example 'ユーザを更新できない' do
      end
    end

    context '「ユーザ一覧画面へ」のリンクを押下した場合' do
      example 'ユーザ一覧画面へ遷移する' do
      end
    end
  end
end
