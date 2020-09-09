require 'rails_helper'

RSpec.feature "Session", type: :feature do
  # サインアップ画面からログインができ、ログアウトできる
  feature 'SignUp' do
    scenario "can sign up" do
      # サインアップ画面へ移動
      visit signup_path

      # サインアップフォームへ入力
      fill_in 'user[last_name]', with: 'サインアップ'
      fill_in 'user[first_name]', with: '太郎'
      fill_in 'user[email]', with: 'signup@gmail.com'
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button 'サインアップ'

      # ログインができている
      expect(page).to have_content 'ユーザーが登録されました'

      # ログアウトができる
      click_link 'ログアウト'
      expect(page).to have_content 'ログイン'
    end
  end

  # ログイン画面からログインができ、ログアウトできる
  feature 'LogIn' do
    let!(:users){create(:valid_sample_user)}
    scenario "can log in" do
      # ログイン画面へ移動
      visit login_path

      # ログインフォームへ入力
      fill_in 'email', with: 'user1@sample.com'
      fill_in 'password', with: 'password1'
      click_button 'サインイン'

      # ログインができている
      expect(page).to have_content 'ログインしました。'

      # ログアウトができる
      click_link 'ログアウト'
      expect(page).to have_content 'ログイン'
    end
  end
end