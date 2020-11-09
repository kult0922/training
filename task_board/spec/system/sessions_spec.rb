require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let!(:user) { create(:user) }

  describe '#create' do
    before { visit login_path }
    subject do
      fill_in 'session_email', with: user_email
      fill_in 'session_password', with: user_password
      click_button 'ログイン'
      page
    end

    context 'success to login' do
      let(:user_email) { user.email }
      let(:user_password) { user.password }
      it { is_expected.to have_current_path root_path }
    end

    context 'fail to login' do
      context 'non-existent user' do
        let(:user_email) { 'non-existent_user@test.com' }
        let(:user_password) { user.password }
        it { is_expected.to have_current_path login_path }
        it { is_expected.to have_content 'メールアドレスかパスワードを確認してください。' }
      end

      context 'incorrect password' do
        let(:user_email) { user.email }
        let(:user_password) { 'wrong_password' }
        it { is_expected.to have_current_path login_path }
        it { is_expected.to have_content 'メールアドレスかパスワードを確認してください。' }
      end
    end
  end

  describe '#destroy' do
    before do
      visit login_path
      fill_in 'session_email', with: user.email
      fill_in 'session_password', with: user.password
      click_button 'ログイン'
    end
    it 'logout' do
      click_link 'ログアウト'
      expect(page).to have_current_path login_path
    end
  end
end
