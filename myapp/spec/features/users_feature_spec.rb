require 'rails_helper'
require 'capybara/rspec'

describe 'User', type: :feature do
  describe 'create' do
    context 'when user create' do
      it 'show success message' do
        visit new_user_path
        fill_in 'ユーザー名', with: 'Test'
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'password'
        fill_in 'Password confirmation', with: 'password'
        click_button '登録'
        expect(page).to have_content 'ユーザー登録ができました'
      end
    end

    context 'if you have account' do
      it 'show login form' do
        visit new_user_path
        click_link 'こちら'
        expect(page).to have_content 'Login'
      end
    end
  end
end
