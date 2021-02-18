# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  # 管理者ユーザ
  let(:admin_authority) { create(:authority, role: 0, name: '管理者') }
  let(:admin_user) { create(:user, login_id: 'yokuno1', name: '管理者', authority_id: admin_authority.id) }
  let!(:admin_task) { create(:task, name: '管理者のタスク', user_id: admin_user.id) }

  # 一般ユーザ
  let(:general_authority) { create(:authority, role: 1, name: '一般') }
  let(:general_user) { create(:user, login_id: 'yokuno2', name: '一般', authority_id: general_authority.id) }
  let!(:general_task) { create(:task, name: '一般のタスク', user_id: general_user.id) }

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
      visit root_path
      fill_in 'login_id', with: login_id
      fill_in 'password', with: password
      click_button 'ログイン'
    end

    context '存在するログインIDとパスワードを入力してログインボタンを押下した場合' do
      context '管理者ユーザの場合' do
        let(:login_id) { admin_user.login_id }
        let(:password) { admin_user.password }
        example 'ユーザ管理画面に遷移する' do
          expect(current_path).to eq admin_users_path
        end
        example 'ユーザ一覧が表示される' do
          expect(page).to have_content admin_user.name
          expect(page).to have_content general_user.name
        end
      end

      context '一般ユーザの場合' do
        let(:login_id) { general_user.login_id }
        let(:password) { general_user.password }
        example 'タスク一覧画面に遷移する' do
          expect(current_path).to eq tasks_path
        end
        example '自身のタスクのみが表示される' do
          expect(page).to have_content general_task.name
          expect(page).not_to have_content admin_task.name
        end
      end
    end

    context '存在しないログインIDを入力してログインボタンを押下した場合' do
      let(:login_id) { 'non-existent_user' }
      let(:password) { admin_user.password }
      example 'ログインに失敗する' do
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログインIDかパスワードを確認してください。'
      end
    end

    context '誤ったパスワードを入力してログインボタンを押下した場合' do
      let(:login_id) { admin_user.login_id }
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
      visit login_path
      fill_in 'login_id', with: login_id
      fill_in 'password', with: password
      click_button 'ログイン'
    end

    context 'ログイン後、ログアウトボタンを押下した場合' do
      context 'ログイン後、ログアウトボタンを押下した場合' do
        context '管理者ユーザの場合' do
          let(:login_id) { admin_user.login_id }
          let(:password) { admin_user.password }
          example 'ログアウトし、ログイン画面に遷移する' do
            page.accept_confirm do
              click_button 'ログアウト'
            end
            expect(page).to have_content 'ログアウトしました。'
            expect(page).to have_current_path login_path
          end
        end

        context '一般ユーザの場合' do
          let(:login_id) { general_user.login_id }
          let(:password) { general_user.password }
          example 'ログアウトし、ログイン画面に遷移する' do
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

  describe 'tasks' do
    context 'ログインしていない状態でタスク管理画面にアクセスした場合' do
      before { visit tasks_path }
      example 'ログイン画面に遷移する' do
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログイン'
      end
    end
  end
end
