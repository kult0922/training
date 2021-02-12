# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before :all do
    @authority_admin =
      create(:authority,
             role: 0,
             name: '管理者')

    @authority_general =
      create(:authority,
             role: 1,
             name: '一般')
  end

  after :all do
    DatabaseCleaner.clean_with(:truncation)
  end

  let(:admin_user) { create(:user, id: 1, login_id: 'test_1', authority_id: @authority_admin.id) }
  let(:general_user) { create(:user, id: 2, login_id: 'test_2', authority_id: @authority_general.id) }
  let!(:admin_task) { create(:task, creation_date: Time.current + 5.days, user_id: admin_user.id) }
  let!(:general_task) { create(:task, creation_date: Time.current + 6.days, user_id: general_user.id) }

  describe '#index' do
    before { visit admin_users_path }
    context 'トップページにアクセスした場合' do
      example 'ユーザ一覧が表示される' do
        expect(current_path).to eq admin_users_path
        expect(page).to have_content admin_user.name
      end
    end

    context 'タスク数のリンクを押下した場合' do
      example 'ユーザのタスク一覧が表示される' do
        click_link 'show_task_link_' + admin_user.id.to_s
        switch_to_window(windows.last)
        expect(current_path).to eq admin_user_path(admin_user.id)
        expect(page).to have_content admin_task.name
      end
    end

    context 'ユーザ編集ボタンを押下した場合' do
      example 'ユーザ編集画面に遷移する' do
        click_link 'edit_link_' + admin_user.id.to_s
        expect(current_path).to eq edit_admin_user_path(admin_user.id)
      end
    end

    context 'ユーザ削除ボタンを押下した場合' do
      example '対象ユーザと対応づくタスクが全て削除される' do
        page.accept_confirm do
          click_link 'delete_link_' + admin_user.id.to_s
        end
        expect(current_path).not_to eq admin_user_path(admin_user.id)
        expect(Task.where(user_id: general_user.id).count).to eq 1
        expect(Task.where(user_id: admin_user.id).count).to eq 0
        expect(page).to have_content '削除しました。'
      end
    end

    context 'ユーザ作成のリンクを押下した場合' do
      example 'ユーザ作成画面に遷移する' do
        click_link 'ユーザ作成'
        expect(current_path).to eq new_admin_user_path
      end
    end

    context 'ログアウトボタンを押下した場合' do
      example 'ログアウトし、ログイン画面に遷移する' do
        page.accept_confirm do
          click_button 'ログアウト'
        end
        expect(page).to have_current_path login_path
        expect(page).to have_content 'ログアウトしました。'
      end
    end
  end

  describe '#show(user_id)' do
    before { visit admin_users_path }
    context 'ユーザタスク一覧を押下、閉じるボタンを押下した場合' do
      example 'ユーザタスク一覧画を閉じる' do
        click_link 'show_task_link_' + admin_user.id.to_s
        switch_to_window(windows.last)
        expect(current_path).to eq admin_user_path(admin_user.id)
        expect(page).to have_content admin_task.name
        click_button '閉じる'
        switch_to_window(windows.first)
        expect(page).to have_current_path admin_users_path
      end
    end
  end

  describe '#new' do
    before { visit new_admin_user_path }
    context '全項目を入力し、登録ボタンを押下した場合' do
      let(:login_id) { 'test_id' }
      let(:password) { 'test_pass' }
      let(:name) { 'test_name' }
      let(:authority) { '一般' }
      before do
        fill_in 'login_id', with: login_id
        fill_in 'password', with: password
        fill_in 'name', with: name
        select authority, from: 'user[authority_id]'
      end
      example 'ユーザを登録できる' do
        click_button '登録'
        expect(page).to have_content '登録が完了しました。'
      end
    end

    context '必須項目を入力せず、登録ボタンを押下した場合' do
      example 'ユーザを登録できない' do
        click_button '登録'
        expect(page).to have_content '登録に失敗しました。'
      end
    end

    context '「ユーザ一覧画面へ」のリンクを押下した場合' do
      example 'ユーザ一覧画面へ遷移する' do
        click_link 'ユーザ一覧画面へ'
        expect(current_path).to eq admin_users_path
      end
    end
  end

  describe '#edit' do
    before { visit edit_admin_user_path(admin_user.id) }
    context '全項目を入力し、更新ボタンを押下した場合' do
      let(:login_id) { 'id' }
      let(:password) { 'pass' }
      let(:name) { 'name' }
      let(:authority) { '一般' }
      before do
        fill_in 'login_id', with: login_id
        fill_in 'password', with: password
        fill_in 'name', with: name
        select authority, from: 'user[authority_id]'
      end
      example 'ユーザを更新できる' do
        click_button '更新'
        expect(page).to have_content '更新が完了しました。'
      end
    end

    context '必須項目を入力せず、更新ボタンを押下した場合' do
      let(:login_id) { '' }
      before do
        fill_in 'login_id', with: login_id
      end
      example 'ユーザを更新できない' do
        click_button '更新'
        expect(page).to have_content '更新に失敗しました。'
      end
    end

    context '「ユーザ一覧画面へ」のリンクを押下した場合' do
      example 'ユーザ一覧画面へ遷移する' do
        click_link 'ユーザ一覧画面へ'
        expect(current_path).to eq admin_users_path
      end
    end
  end
end
