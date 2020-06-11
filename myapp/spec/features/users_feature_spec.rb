require 'rails_helper'
require 'capybara/rspec'

describe 'User', type: :feature do
  describe 'create' do
    context 'when user create' do
      it 'show success message' do
        visit new_user_path
        fill_in User.human_attribute_name(:name), with: 'Test'
        fill_in User.human_attribute_name(:email), with: 'test@example.com'
        fill_in User.human_attribute_name(:password), with: 'password'
        fill_in User.human_attribute_name(:password_confirmation), with: 'password'
        click_button '登録'
        expect(page).to have_content 'ユーザー登録ができました'
      end
    end

    context 'if you have account' do
      it 'show login form' do
        visit new_user_path
        click_link 'こちら'
        expect(page).to have_content I18n.t('sessions.new.login')
      end
    end
  end
end
