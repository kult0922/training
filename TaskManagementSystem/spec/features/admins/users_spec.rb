# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'AdminUser', type: :feature do
  # ユーザー一覧
  feature 'UserIndex' do
    let!(:user) { create(:login_user) }
    scenario 'show all users' do
      # ユーザー一覧画面へ移動
      visit admins_users_path

      # ページタイトルが表示されている
      expect(page).to have_content('ユーザー一覧')

      # テーブルのタイトルが表示されている
      expect(page).to have_content('ID')
      expect(page).to have_content('姓')
      expect(page).to have_content('名')
      expect(page).to have_content('メールアドレス')
      expect(page).to have_content('タスク合計値')
      expect(page).to have_content('詳細')
      expect(page).to have_content('編集')
      expect(page).to have_content('削除')

      # テーブルにユーザー情報が出力されている
      expect(page).to have_content(user.id)
      expect(page).to have_content(user.last_name)
      expect(page).to have_content(user.first_name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.tasks.count)

      # リンクの存在確認
      click_link('詳細')
      visit admins_users_path
      click_link('編集')

      # 削除できているか確認
      visit admins_users_path
      click_link('削除')
      expect(User.all.count).to eq 0
    end
  end

  # ユーザー作成
  feature 'UserCreate' do
    scenario 'can create users' do
      # ユーザー作成画面へ移動
      visit admins_users_path
      click_link('ユーザー登録')

      # タイトルが表示される
      expect(page).to have_content('ユーザー登録')

      # フォームのラベルが表示されている
      expect(page).to have_content('姓')
      expect(page).to have_content('名')
      expect(page).to have_content('メールアドレス')
      expect(page).to have_content('パスワード')
      expect(page).to have_content('パスワード(確認)')

      # フォームに入力
      fill_in('姓', with: '田中')
      fill_in('名', with: '太郎')
      fill_in('メールアドレス', with: 'tanaka_taro@gmail.com')
      fill_in('パスワード', with: 'password')
      fill_in('パスワード(確認)', with: 'password')

      # ユーザーを登録できている
      click_button('登録')
      expect(User.all.count).to eq 1
    end
  end
  # ユーザー詳細
  feature 'UserShow' do
    let!(:user) { create(:login_user) }
    let!(:task) { create(:valid_sample_task, user_id: user.id) }
    scenario 'can show detail of a user' do
      # ユーザー詳細画面へ移動
      visit admins_users_path
      visit admins_user_path(user)

      # ユーザーの情報に関するラベルが表示される
      expect(page).to have_content('ID')
      expect(page).to have_content('姓')
      expect(page).to have_content('名')
      expect(page).to have_content('メールアドレス')
      expect(page).to have_content('タスク合計値')

      # テーブルにユーザー情報が出力されている
      expect(page).to have_content(user.id)
      expect(page).to have_content(user.last_name)
      expect(page).to have_content(user.first_name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.tasks.count)

      # ユーザーに紐づくタスクを一覧として見れる
      click_link('タスク一覧')
      # タスク一覧のタイトルが表示される
      expect(page).to have_content("タスク一覧(#{user.last_name}#{user.first_name}さん)")
      # テーブルにタスクの詳細タイトルが表示されている
      expect(page).to have_content('優先度')
      expect(page).to have_content('タスク名')
      expect(page).to have_content('説明')
      expect(page).to have_content('終了期限')
      expect(page).to have_content('作成日')
      expect(page).to have_content('ステータス')
      expect(page).to have_content('ラベル名')
      # テーブルにタスクの情報が表示されている
      expect(page).to have_content(task.priority)
      expect(page).to have_content(task.title)
      expect(page).to have_content(task.description)
      expect(page).to have_content(task.deadline.strftime('%Y/%m/%d'))
      expect(page).to have_content(task.created_at.strftime('%Y/%m/%d'))
      expect(page).to have_content(task.status_i18n)
      expect(page).to have_content('ラベル')

      # ユーザー詳細画面へ移動
      visit admins_users_path
      click_link('詳細')

      # リンクの存在確認
      click_link('編集')
      visit admins_users_path
      click_link('詳細')

      # 詳細画面からユーザーを削除できる
      click_link('削除')
      expect(User.all.count).to eq 0
    end
  end

  # ユーザー編集
  feature 'UserEdit' do
    let!(:user) { create(:login_user) }
    scenario 'can edit information of user' do
      # ユーザー編集画面へ移動
      visit admins_users_path
      click_link('編集')

      # タイトルが表示される
      expect(page).to have_content('ユーザー編集')

      # フォームのラベルが表示されている
      expect(page).to have_content('姓')
      expect(page).to have_content('名')
      expect(page).to have_content('メールアドレス')
      expect(page).to have_content('パスワード')
      expect(page).to have_content('パスワード(確認)')

      # フォームに入力
      fill_in('姓', with: '筋肉')
      fill_in('名', with: '万太郎')
      fill_in('メールアドレス', with: 'muscle_mantaro@gmail.com')
      fill_in('パスワード', with: 'kinniku')
      fill_in('パスワード(確認)', with: 'kinniku')

      # ユーザーを編集できている
      click_button('編集')
      expect(page).to have_content('筋肉')
      expect(page).to have_content('万太郎')
      expect(page).to have_content('muscle_mantaro@gmail.com')
    end
  end
end
