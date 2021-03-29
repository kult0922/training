# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login', type: :system do
  let!(:user) { create(:user, role_id: 'member') }

  describe 'not logged in' do
    it 'access login page' do
      visit login_path
      expect(page).to have_content 'ログイン'
    end

    it 'loggin in' do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'ログイン'
      expect(page).to have_content 'ログアウト'
    end
  end

  describe 'logging in' do
    before 'login' do
      visit login_path
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'ログイン'
    end

    it 'logout' do
      visit tasks_path
      click_on 'ログアウト'
      expect(page).to have_content 'ログイン'
    end

    it 'access login page' do
      visit login_path
      expect(page).to have_content 'ログアウト'
    end
  end
end
