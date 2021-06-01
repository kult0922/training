# frozen_string_literal: true

require 'rails_helper'

describe 'Users', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  describe 'ログイン' do
    context '正しいユーザーIDとパスワードを入力してログインしたとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
      end

      it 'タスク一覧ページが表示される' do
        expect(page).to have_current_path tasks_path
      end
    end

    context 'ユーザーIDとパスワードの組み合わせが正しくないとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'pazzword'
        click_button 'ログイン'
      end

      it 'エラーが表示される' do
        expect(page).to have_current_path root_path
        expect(page).to have_selector '.alert', text: 'ログインに失敗しました。メールアドレスとパスワードを確認してください'
      end
    end
  end

  describe 'ログアウト' do
    before do
      visit root_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      click_link 'ログアウト'
    end

    it 'ログインページとflashメッセージが表示される' do
      expect(page).to have_current_path root_path
      expect(page).to have_selector '.notice', text: 'ログアウトしました'
    end

    it 'リンクが表示される' do
      expect(page).to have_link 'サインアップ'
    end
  end

  describe 'サインアップ' do
    before do
      visit root_path
      click_link 'サインアップ'
      fill_in 'アカウント名', with: 'testuser'
      fill_in 'メールアドレス', with: 'abc@example.com'
      fill_in 'パスワード', with: 'Ab12345+'
      fill_in '確認用パスワード', with: 'Ab12345+'
      click_button '作成する'
    end

    it 'タスク一覧ページとユーザの名前が表示される' do
      expect(page).to have_current_path tasks_path
      expect(page).to have_content 'testuser でログイン中'
    end
  end
end
