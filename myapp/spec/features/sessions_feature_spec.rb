require 'rails_helper'
require 'capybara/rspec'

describe 'Session', type: :feature do
  let(:user) { create(:user) }
  describe 'login' do
    context 'when login' do
      it 'show login message' do
        visit login_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on 'ログイン'
        expect(page).to have_content 'ログインしました'
      end
    end

    context 'when inputting wrong email' do
      it 'show error message' do
        visit login_path
        fill_in 'Email', with: 'a'
        fill_in 'Password', with: user.password
        click_on 'ログイン'
        expect(page).to have_content 'emailと一致するユーザーがいません'
      end
    end

    context 'when inputting wrong password' do
      it 'show error message' do
        visit login_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: 'a'
        click_on 'ログイン'
        expect(page).to have_content 'パスワードが一致しません'
      end
    end

    context 'if you dont have account' do
      it 'show users new' do
        visit login_path
        click_link 'こちら'
        expect(page).to have_content 'ユーザー登録'
      end
    end
  end

  describe 'logout' do
    context 'when logout' do
      it 'show logout message' do
        visit login_path
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        click_on 'ログイン'
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end
end
