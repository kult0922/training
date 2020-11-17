require 'rails_helper'

RSpec.describe User, type: :system do
  describe '#create' do
    let!(:user) { create(:user) }
    let(:user_name) { 'new_user' }
    let(:user_email) { 'new_user@test.com' }
    let(:user_password) { 'password' }
    let(:user_password_confirmation) { user_password }

    before { visit new_user_path }

    subject do
      fill_in 'user_name', with: user_name
      fill_in 'user_email', with: user_email
      fill_in 'user_password', with: user_password
      fill_in 'user_password_confirmation', with: user_password_confirmation
      click_button '会員登録'
      page
    end

    context 'success to signup' do
      it { is_expected.to have_current_path root_path }
      it { is_expected.to have_content "User Name: #{user_name}" }
    end

    context 'fail to signup' do
      context 'user email already existing' do
        let(:user_email) { user.email }
        it { is_expected.to have_content 'メールアドレスはすでに存在します' }
      end

      context 'password and password_confirmation are not matched' do
        let(:user_password_confirmation) { 'wrong_password' }
        it { is_expected.to have_content 'パスワード確認とパスワードの入力が一致しません' }
      end
    end
  end
end
