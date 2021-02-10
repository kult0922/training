# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let(:test_authority) { create(:authority, role: 0, name: 'test') }
  let(:user1) { create(:user, login_id: 'yokuno1', authority_id: test_authority.id) }
  let!(:added_task1) { create(:task, creation_date: Time.current + 1.day, user_id: user1.id) }
  let(:login_id) { user1.login_id }
  let(:password) { user1.password }

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
      let(:user2) { create(:user, login_id: 'yokuno2', authority_id: test_authority.id) }
      let!(:added_task2) { create(:task, creation_date: Time.current + 1.day, user_id: user2.id) }
      example 'ログインに成功する' do
        expect(current_path).to eq root_path
      end
      example '自身のタスクのみが表示される' do
        expect(page).to have_content added_task1.name
        expect(page).not_to have_content added_task2.name
      end
    end

    context '存在しないログインIDを入力してログインボタンを押下した場合' do
      let(:login_id) { 'non-existent_user' }
      example 'ログインに失敗する' do
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログインIDかパスワードを確認してください。'
      end
    end

    context '誤ったパスワードを入力してログインボタンを押下した場合' do
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
      fill_in 'login_id', with: user1.login_id
      fill_in 'password', with: user1.password
      click_button 'ログイン'
    end

    context 'ログイン後、ログアウトボタンを押下した場合' do
      example 'ログアウトし、ログイン画面に遷移する' do
        page.accept_confirm do
          click_button 'ログアウト'
        end
        expect(page).to have_content 'ログアウトしました。'
        expect(page).to have_current_path login_path
      end
    end
  end

  describe 'root' do
    context 'ログインしていない状態でタスク管理画面にアクセスした場合' do
      before { visit root_path }
      example 'ログイン画面に遷移する' do
        expect(current_path).to eq login_path
        expect(page).to have_content 'ログイン'
      end
    end
  end
end
