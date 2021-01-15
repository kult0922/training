# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before :all do
    # テストデータ：管理者ユーザ
    @test_authority_admin =
      create(:authority,
             id: 1,
             role: 0,
             name: '管理者')
    @test_user_admin =
      create(:user,
             id: 1,
             login_id: 'test_1',
             name: '管理者ユーザ',
             authority_id: @test_authority_admin.id)
    @test_task_admin =
      create(:task,
             id: 1,
             creation_date: Time.current + 5.days,
             user_id: @test_user_admin.id)

    # テストデータ：管理者ユーザ２
    @test_user_admin_s =
      create(:user,
             id: 2,
             login_id: 'test_2',
             name: '管理者ユーザ_サブ',
             authority_id: @test_authority_admin.id)
    @test_task_admin_s =
      create(:task,
             id: 2,
             creation_date: Time.current + 5.days,
             user_id: @test_user_admin_s.id)

    # テストデータ：一般ユーザ
    @test_authority_general =
      create(:authority,
             id: 2,
             role: 1,
             name: '一般')
    @test_user_general =
      create(:user,
             id: 3,
             login_id: 'test_3',
             name: '一般ユーザ',
             authority_id: @test_authority_general.id)
    @test_task_general =
      create(:task,
             id: 3,
             creation_date: Time.current + 6.days,
             user_id: @test_user_general.id)
  end

  after :all do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe '#index(admin)' do
    before do
      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:session).and_return(user_id: @test_user_admin.id)
      visit admin_users_path
    end
    context '管理者ユーザの場合' do
      context 'ユーザ管理画面にアクセスした場合' do
        example 'ユーザ一覧が表示される' do
          expect(current_path).to eq admin_users_path
          expect(page).to have_content @test_user_admin.name
        end
      end

      context 'タスク数のリンクを押下した場合' do
        example 'ユーザのタスク一覧が表示される' do
          click_link "show_user_link_#{@test_user_admin.id}"
          switch_to_window(windows.last)
          expect(current_path).to eq admin_user_path(@test_user_admin.id)
          expect(page).to have_content @test_task_admin.name
        end
      end

      context 'ユーザ編集ボタンを押下した場合' do
        example 'ユーザ編集画面に遷移する' do
          click_link "edit_user_link_#{@test_user_admin.id}"
          expect(current_path).to eq edit_admin_user_path(@test_user_admin.id)
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
  end

  describe '#index(general)' do
    before do
      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:session).and_return(user_id: @test_user_general.id)
      visit admin_users_path
    end
    context '一般ユーザの場合' do
      context 'ユーザ管理画面にアクセスした場合' do
        example 'ユーザ管理画面にアクセスできず、タスク一覧画面に遷移する' do
          expect(page).to have_current_path tasks_path
          expect(page).to have_content @test_task_general.name
        end
      end
    end
  end

  describe '#show(user_id)' do
    before do
      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:session).and_return(user_id: @test_user_admin.id)
      visit admin_users_path
    end
    context 'ユーザタスク一覧を押下し、閉じるボタンを押下した場合' do
      example 'ユーザタスク一覧画を閉じる' do
        click_link "show_user_link_#{@test_user_admin.id}"
        switch_to_window(windows.last)
        expect(current_path).to eq admin_user_path(@test_user_admin.id)
        expect(page).to have_content @test_task_admin.name
        click_button '閉じる'
        switch_to_window(windows.first)
        expect(page).to have_current_path admin_users_path
      end
    end
  end

  describe '#new' do
    before do
      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:session).and_return(user_id: @test_user_admin.id)
      visit new_admin_user_path
    end
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
        expect(page).to have_content '登録が完了しました。ログインID：' + login_id
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
    before do
      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:session).and_return(user_id: @test_user_admin.id)
      visit edit_admin_user_path(@test_user_admin.id)
    end
    context '全項目を入力し、更新ボタンを押下した場合' do
      let(:login_id) { 'test_id' }
      let(:password) { 'pass' }
      let(:name) { 'name' }
      let(:authority) { '一般' }
      before do
        fill_in 'login_id', with: ''
        fill_in 'login_id', with: login_id
        fill_in 'password', with: password
        fill_in 'name', with: name
        select authority, from: 'user[authority_id]'
      end
      example 'ユーザを更新できる' do
        click_button '更新'
        expect(page).to have_content '更新が完了しました。ログインID：' + login_id
      end
    end

    context '必須項目を入力せず、更新ボタンを押下した場合' do
      let(:login_id) { '' }
      let(:password) { '' }
      let(:name) { '' }
      before do
        fill_in 'login_id', with: login_id
        fill_in 'password', with: password
        fill_in 'name', with: name
      end
      example 'ユーザを更新できない' do
        click_button '更新'
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

  describe '#delete' do
    before do
      allow_any_instance_of(ActionDispatch::Request)
        .to receive(:session).and_return(user_id: @test_user_admin.id)
      visit admin_users_path
    end

    context 'ユーザ一覧画面でユーザ削除ボタンを押下した場合' do
      context 'ログイン中の管理ユーザでは無い場合' do
        example '対象ユーザと対応づくタスクが全て削除される' do
          page.accept_confirm do
            click_link "delete_user_link_#{@test_user_admin_s.id}"
          end
          expect(current_path).not_to eq admin_user_path(@test_user_admin_s.id)
          expect(Task.where(user_id: @test_user_admin.id).count).to eq 1
          expect(Task.where(user_id: @test_user_admin_s.id).count).to eq 0
          expect(Task.where(user_id: @test_user_general.id).count).to eq 1
          expect(page).to have_content '削除しました。ログインID：'
          + @test_user_admin_s.login_id
        end
      end

      context '一般ユーザの場合' do
        example '対象ユーザと対応づくタスクが全て削除される' do
          page.accept_confirm do
            click_link "delete_user_link_#{@test_user_general.id}"
          end
          expect(current_path).not_to eq admin_user_path(@test_user_general.id)
          expect(Task.where(user_id: @test_user_admin.id).count).to eq 1
          expect(Task.where(user_id: @test_user_admin_s.id).count).to eq 1
          expect(Task.where(user_id: @test_user_general.id).count).to eq 0
          expect(page).to have_content '削除しました。ログインID：'
          + @test_user_general.login_id
        end
      end

      context 'ログイン中のユーザの場合' do
        example '対象ユーザが削除されない' do
          page.accept_confirm do
            click_link "delete_user_link_#{@test_user_admin.id}"
          end
          expect(current_path).not_to eq admin_user_path(@test_user_admin.id)
          expect(Task.where(user_id: @test_user_admin.id).count).to eq 1
          expect(Task.where(user_id: @test_user_admin_s.id).count).to eq 1
          expect(Task.where(user_id: @test_user_general.id).count).to eq 1
          expect(page).to have_content 'ログイン中のユーザは削除できません。ログインID：'
          + @test_user_admin.login_id
        end
      end
    end
  end
end
