# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:user) { create(:user, role_id: 'member') }

  describe 'not logged in' do
    it 'create user' do
      visit new_user_path
      expect(page).to have_button '登録する'
      fill_in 'user_email', with: 'test@rakuten.com'
      fill_in 'user_password', with: 'test'
      click_button '登録する'
      expect(page).to have_content '成功しました。'
    end
  end

  describe 'logging in' do
    before 'login' do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'ログイン'
    end

    it 'create user' do
      visit new_user_path
      expect(page.current_path).to eq('/tasks')
    end
  end
end
