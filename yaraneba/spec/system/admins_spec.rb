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

  describe 'create user' do
    context 'fill email' do
      it 'fault' do
        visit admin_users_new_path
        fill_in 'user_email', with: 'test@rakuten.com'
        click_button '登録する'
        expect(page).to have_content '失敗しました。'
      end
    end

    context 'fill password' do
      it 'fault' do
        visit admin_users_new_path
        fill_in 'user_password', with: 'test'
        click_button '登録する'
        expect(page).to have_content '失敗しました。'
      end
    end

    context 'fill email, password' do
      it 'success' do
        visit admin_users_new_path
        fill_in 'user_email', with: 'test@rakuten.com'
        fill_in 'user_password', with: 'test'
        click_button '登録する'
        expect(page).to have_content '成功しました。'
      end
    end
  end

  describe 'update user' do
    context 'fill email' do
      it 'success' do
        visit admin_users_path
        click_on '編集'
        fill_in 'user_email', with: 'test'
        click_on '更新する'
        expect(page).to have_content '成功しました。'
      end
    end

    context 'fill password' do
      it 'success' do
        visit admin_users_path
        click_on '編集'
        fill_in 'user_password', with: 'testtesttest'
        click_on '更新する'
        expect(page).to have_content '成功しました。'
      end
    end

    context 'fill in login user' do
      it 'no role_id field' do
        visit admin_users_path
        click_on '編集'
        expect(page).to have_no_field('user_role_id')
      end
    end
  end

  describe 'delete' do
    context 'click not login user' do
      it 'success' do
        create(:user, role_id: 'member')
        visit admin_users_path
        page.accept_confirm do
          click_on 'delete_1'
        end
        expect(page).to have_content '成功しました。'
      end
    end

    context 'click login user' do
      it 'fault' do
        visit admin_users_path
        page.accept_confirm do
          click_on '削除', match: :first
        end
        expect(page).to have_content '失敗しました。'
      end
    end
  end
end
