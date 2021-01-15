# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  # テストデータ：管理者ユーザ
  let!(:test_authority_admin) do
    create(:authority, id: 1, role: 0, name: '管理者')
  end
  let!(:test_user_admin) do
    create(:user,
           id: 1,
           login_id: 'yokuno1',
           authority_id: test_authority_admin.id)
  end
  let!(:added_task1) do
    create(:task,
           creation_date: Time.current + 1.day,
           user_id: test_user_admin.id)
  end

  # テストデータ：一般ユーザ
  let!(:test_authority_general) do
    create(:authority, id: 2, role: 1, name: '一般')
  end
  let!(:test_user_general) do
    create(:user, id: 2,
                  login_id: 'yokuno2',
                  authority_id: test_authority_general.id)
  end
  let!(:added_task2) do
    create(:task,
           creation_date: Time.current + 1.day,
           user_id: test_user_general.id)
  end

  describe 'root' do
    context 'ルートパスにアクセスした場合' do
      before { visit root_path }
      example 'ログイン画面が表示される' do
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログイン'
      end
    end
  end

  describe '#index' do
    context 'ログイン画面にアクセスした場合' do
      before { visit login_path }
      example 'ログイン画面が表示される' do
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログイン'
      end
    end
  end

  describe '#create' do
    before do
      visit login_path
      fill_in 'login_id', with: login_id
      fill_in 'password', with: password
      click_button 'ログイン'
    end

    context '存在するログインIDとパスワードを入力してログインボタンを押下した場合' do
      context '管理者ユーザの場合' do
        let(:login_id) { test_user_admin.login_id }
        let(:password) { test_user_admin.password }
        example 'ユーザ管理画面に遷移する' do
          expect(current_path).to eq admin_users_path
        end
        example 'ユーザ一覧が表示される' do
          expect(page).to have_content test_user_admin.name
        end
      end

      context '一般ユーザの場合' do
        let(:login_id) { test_user_general.login_id }
        let(:password) { test_user_general.password }
        example 'タスク一覧画面に遷移する' do
          expect(current_path).to eq tasks_path
        end
        example '自身のタスクのみが表示される' do
          expect(page).to have_content added_task2.name
          expect(page).not_to have_content added_task1.name
        end
      end
    end

    context '存在しないログインIDを入力してログインボタンを押下した場合' do
      let(:login_id) { 'non-existent_user' }
      let(:password) { test_user_admin.password }
      example 'ログインに失敗する' do
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログインIDかパスワードを確認してください。'
      end
    end

    context '誤ったパスワードを入力してログインボタンを押下した場合' do
      let(:login_id) { test_user_admin.login_id }
      let(:password) { 'wrong_password' }
      example 'ログインに失敗する' do
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログインIDかパスワードを確認してください。'
      end
    end

    context 'ログインIDとパスワードを未入力でログインボタンを押下した場合' do
      let(:login_id) { '' }
      let(:password) { '' }
      example 'ログインに失敗する' do
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログインIDかパスワードを確認してください。'
      end
    end
  end

  describe '#destroy' do
    before do
      visit root_path
      fill_in 'login_id', with: login_id
      fill_in 'password', with: password
      click_button 'ログイン'
    end
    context 'ログイン後、ログアウトボタンを押下した場合' do
      context '管理者ユーザの場合' do
        let(:login_id) { test_user_admin.login_id }
        let(:password) { test_user_admin.password }
        example 'ログアウトに成功する' do
          page.accept_confirm do
            click_button 'ログアウト'
          end
          expect(page).to have_content 'ログアウトしました。'
          expect(page).to have_current_path login_path
        end
      end

      context '一般ユーザの場合' do
        let(:login_id) { test_user_general.login_id }
        let(:password) { test_user_general.password }
        example 'ログアウトに成功する' do
          page.accept_confirm do
            click_button 'ログアウト'
          end
          expect(page).to have_content 'ログアウトしました。'
          expect(page).to have_current_path login_path
        end
      end
    end
  end
end
