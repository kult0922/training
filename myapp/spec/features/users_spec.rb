require 'rails_helper'
require 'capybara/rspec'

describe 'User', type: :feature do
  describe 'create' do
    context 'when user create' do
      it 'show success message' do
        visit new_user_path
        fill_in 'ユーザー名', with: 'Test'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        click_button '登録'
        expect(page).to have_content 'ユーザー登録ができました'
      end
    end

    context 'if user blank' do
      it 'show error message' do
        visit new_user_path
        fill_in 'ユーザー名', with: ''
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        click_button '登録'
        expect(page).to have_content 'ユーザー名を入力してください'
      end
    end

    context 'when email is blank' do
      it 'show error message' do
        visit new_user_path
        fill_in 'ユーザー名', with: 'Test'
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        click_button '登録'
        expect(page).to have_content 'メールアドレスを入力してください'
      end
    end

    context 'when inputting wrong email' do
      it 'show error message' do
        visit new_user_path
        fill_in 'ユーザー名', with: 'Test'
        fill_in 'メールアドレス', with: 'a'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        click_button '登録'
        expect(page).to have_content 'メールアドレスは不正な値です'
      end
    end

    context 'when inputting existing email' do
      let!(:user) { create(:user) }
      it 'show error message' do
        visit new_user_path
        fill_in 'ユーザー名', with: 'Test'
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'password'
        click_button '登録'
        expect(page).to have_content 'メールアドレスはすでに存在します'
      end
    end

    context 'when password is blank' do
      it 'show error message' do
        visit new_user_path
        fill_in 'ユーザー名', with: 'Test'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: ''
        fill_in 'パスワード（確認用）', with: 'password'
        click_button '登録'
        expect(page).to have_content 'パスワードを入力してください'
      end
    end

    context 'when confirmation password is blank' do
      it 'show error message' do
        visit new_user_path
        fill_in 'ユーザー名', with: 'Test'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: ''
        click_button '登録'
        expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'
      end
    end

    context 'when inputting wrong confirmation passowrd' do
      it 'show error message' do
        visit new_user_path
        fill_in 'ユーザー名', with: 'Test'
        fill_in 'メールアドレス', with: 'test@example.com'
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード（確認用）', with: 'a'
        click_button '登録'
        expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'
      end
    end

    context 'if you have account' do
      it 'show login form' do
        visit new_user_path
        click_link 'こちら'
        expect(page).to have_content 'ログイン'
      end
    end
  end
end