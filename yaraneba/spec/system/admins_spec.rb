# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins', type: :system do
  let!(:user) { create(:user, role_id: 'admin') }

  before 'login' do
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'ログイン'
  end

  describe '#admin' do
    it 'create user' do
      visit admin_users_new_path
      fill_in 'user_email', with: 'test@rakuten.com'
      fill_in 'user_password', with: 'test'
      click_button '登録する'
      expect(page).to have_content '成功しました。'
    end

    it 'update user' do
      visit admin_users_path
      click_on '編集'
      fill_in 'user_email', with: 'test'
      click_on '更新する'
      expect(page).to have_content '成功しました。'
    end

    it 'can not update roles in login user' do
      visit admin_users_path
      click_on '編集'
      expect(page).to have_no_field('user_role_id')
    end

    it 'delete user' do
      create(:user, role_id: 'member')
      visit admin_users_path
      page.accept_confirm do
        click_on 'delete_1'
      end
      expect(page).to have_content '成功しました。'
    end

    it 'can not delete login user' do
      visit admin_users_path
      page.accept_confirm do
        click_on '削除', match: :first
      end
      expect(page).to have_content '失敗しました。'
    end
  end
end
