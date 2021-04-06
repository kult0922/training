# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Login', type: :system do
  let!(:user) { create(:user, role_id: 'member') }

  describe 'display confirmation' do
    context 'login' do
      it 'ログイン is displayed' do
        visit login_path
        expect(page).to have_content 'ログイン'
      end

      it 'ログアウト is displayed' do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: user.password
        click_button 'ログイン'
        expect(page).to have_content 'ログアウト'
      end
    end

    context 'logout' do
      before 'login' do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: user.password
        click_button 'ログイン'
      end

      it 'ログアウト is displayed' do
        visit login_path
        expect(page).to have_content 'ログアウト'
      end

      it 'ログイン is displayed' do
        visit tasks_path
        click_on 'ログアウト'
        expect(page).to have_content 'ログイン'
      end
    end
  end
end
