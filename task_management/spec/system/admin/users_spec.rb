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

  before do
    visit login_path
    fill_in 'login_id', with: admin_user.login_id
    fill_in 'password', with: admin_user.password
    click_button 'ログイン'
  end

  let(:admin_user) { create(:user, login_id: 'admin_user', authority_id: @authority_admin.id) }

  describe '#index' do
    before { visit admin_users_path }
    context 'トップページにアクセスした場合' do
      example 'ユーザ一覧が表示される' do
        expect(current_path).to eq admin_users_path
        expect(page).to have_content admin_user.name
      end
    end

    context 'タスク数のリンクを押下した場合' do
      let!(:admin_task) { create(:task, name: '管理者のタスク', user_id: admin_user.id) }
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
      let(:general_user) { create(:user, login_id: 'general_user', authority_id: @authority_general.id) }
      let!(:admin_task) { create(:task, name: '管理者のタスク', user_id: admin_user.id) }
      let!(:general_task) { create(:task, name: '一般のタスク', user_id: general_user.id) }
      let(:label_A) { create(:label, user_id: general_user.id, name: 'label_A') }
      let!(:rel_A) { create(:task_label_relation, task_id: general_task.id, label_id: label_A.id) }
      example '対象ユーザ、及び対応づくタスク・ラベル・タスクテーブル-ラベルマスタ紐付テーブルが全て削除される' do
        visit admin_users_path
        page.accept_confirm do
          click_link 'delete_link_' + general_user.id.to_s
        end
        expect(current_path).not_to eq admin_user_path(general_user.id)
        expect(Task.where(user_id: general_user.id).count).to eq 0
        expect(Label.where(user_id: general_user.id).count).to eq 0
        expect(TaskLabelRelation.where(task_id: general_task.id).count).to eq 0
        expect(Task.where(user_id: admin_user.id).count).to eq 1
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

    describe 'rooting' do
      before do
        page.accept_confirm { click_button 'ログアウト' }
      end
      context '一般権限のユーザでユーザ管理画面にアクセスした場合' do
        let(:general_user) { create(:user, login_id: 'general_user', authority_id: @authority_general.id) }
        let!(:general_task) { create(:task, name: '一般のタスク', user_id: general_user.id) }
        before do
          fill_in 'login_id', with: login_id
          fill_in 'password', with: password
          click_button 'ログイン'
        end
        let(:login_id) { general_user.login_id }
        let(:password) { general_user.password }
        example 'ユーザ管理画面に遷移できず、404ページが表示される' do
          visit admin_users_path
          expect(page).to have_content 'お探しのページは見つかりませんでした。'
        end
      end

      context 'ユーザ管理画面に遷移できず、404ページが表示される' do
        example '404ページが表示される' do
          visit admin_users_path
          expect(page).to have_content 'お探しのページは見つかりませんでした。'
        end
      end
    end

    describe 'paging' do
      let!(:admin_users) { create_list(:user, 24, authority_id: @authority_admin.id) }
      let!(:general_user) { create(:user, login_id: 'general_user', authority_id: @authority_general.id) }
      before { visit admin_users_path }
      context 'ページングの「最初」リンクを押下した場合' do
        example '最初のページにユーザが25件表示される' do
          click_link '最後'
          click_link '最初'
          expect(page).to have_content admin_user.login_id
          admin_users.each do |admin_user|
            expect(page).to have_content admin_user.login_id
          end
        end
      end

      context 'ページングの「最後」リンクを押下した場合' do
        example '最後のページにユーザが1件表示される' do
          click_link '最後'
          expect(page).to have_content general_user.login_id
        end
      end

      context 'ページングの「前」リンクを押下した場合' do
        example '最初のページにユーザが25件表示される' do
          click_link '次'
          click_link '前'
          expect(page).to have_content admin_user.login_id
          admin_users.each do |admin_user|
            expect(page).to have_content admin_user.login_id
          end
        end
      end

      context 'ページングの「次」リンクを押下した場合' do
        example '最後のページにユーザが1件表示される' do
          click_link '次'
          expect(page).to have_content general_user.login_id
        end
      end

      context 'ページングの「1」リンクを押下した場合' do
        example '最初のページにユーザが25件表示される' do
          click_link '2'
          click_link '1'
          expect(page).to have_content admin_user.login_id
          admin_users.each do |admin_user|
            expect(page).to have_content admin_user.login_id
          end
        end
      end

      context 'ページングの「2」リンクを押下した場合' do
        example '最後のページにユーザが1件表示される' do
          click_link '2'
          expect(page).to have_content general_user.login_id
        end
      end
    end
  end

  describe '#show(user_id)' do
    before { visit admin_users_path }
    context 'ユーザタスク一覧を押下、閉じるボタンを押下した場合' do
      let!(:admin_task) { create(:task, name: '管理者のタスク', user_id: admin_user.id) }
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
        expect(page).to have_content 'ログインIDを入力してください'
        expect(page).to have_content 'パスワードを入力してください'
        expect(page).to have_content 'ユーザ名を入力してください'
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
      let(:password) { '' }
      before do
        fill_in 'login_id', with: login_id
        fill_in 'password', with: password
      end
      example 'ユーザを更新できない' do
        click_button '更新'
        expect(page).to have_content 'ログインIDを入力してください'
        expect(page).to have_content 'パスワードを入力してください'
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
