# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let!(:test_authority) { create(:authority, id: 1, role: 0, name: 'test') }
  let!(:test_user) { create(:user, id: 1, login_id: 'yokuno', authority_id: test_authority.id) }

  describe '#index' do
    context 'ログイン画面にアクセス成功した場合' do
      before { visit login_path }
      it { is_expected.to have_content 'ログイン' }
    end
  end

  describe '#create' do
    before { visit root_path }
    subject do
      fill_in 'login_id', with: login_id
      fill_in 'password', with: password
      click_button 'ログイン'
      page
    end

    context '存在するログインIDとパスワードを入力してログインボタンを押下した場合' do
      let(:login_id) { test_user.login_id }
      let(:password) { test_user.password }
      context 'ログインに成功する' do
        it { is_expected.to have_current_path root_path }
      end
    end

    context '存在しないログインIDを入力してログインボタンを押下した場合' do
      let(:login_id) { 'non-existent_user' }
      let(:password) { test_user.password }
      context 'ログインに失敗する' do
        it { is_expected.to have_current_path login_path }
        it { is_expected.to have_content 'ログインIDかパスワードを確認してください。' }
      end
    end

    context '誤ったパスワードを入力してログインボタンを押下した場合' do
      context 'ログインに失敗する' do
        let(:login_id) { test_user.login_id }
        let(:password) { 'wrong_password' }
        it { is_expected.to have_current_path login_path }
        it { is_expected.to have_content 'ログインIDかパスワードを確認してください。' }
      end
    end

    context 'ログインIDとパスワードを未入力でログインボタンを押下した場合' do
      context 'ログインに失敗する' do
        let(:login_id) { '' }
        let(:password) { '' }
        it { is_expected.to have_current_path login_path }
        it { is_expected.to have_content 'ログインIDかパスワードを確認してください。' }
      end
    end

    describe '#destroy' do
      before do
        visit root_path
        fill_in 'login_id', with: test_user.login_id
        fill_in 'password', with: test_user.password
        click_button 'ログイン'
      end
      context 'ログイン後、ログアウトボタンを押下した場合' do
        it 'logout' do
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
