require 'rails_helper'

RSpec.describe 'User', type: :system do
  let!(:test_user) { create(:test_user) }
  let(:submit) { 'ログイン' }
  let(:error_message) {'メールアドレスもしくはパスワードが正しくありません。'}

  describe 'login' do
    describe 'with blank input' do
      before do
        visit login_path
        click_button submit
      end
      it 'should fail' do
        expect(page).to have_content error_message
      end
    end

    describe 'with inexist user account' do
      before do
        visit login_path
        fill_in 'session_email', with: 'dummy@dummy.com'
        fill_in 'session_password', with: 'dummyPASSWORD12345'
        click_button submit
        end
      it 'should fail' do
        expect(page).to have_content error_message
      end
    end

    describe 'with valid user account' do
      before do
        visit login_path
        fill_in 'session_email', with: test_user.email
        fill_in 'session_password', with: test_user.password
        click_button submit
        end
      it 'should succeed' do
        expect(RSpec.configuration.session[:user_id]).to eq test_user.id
      end
      describe 'log out' do
        before do
          visit root_path
          click_link 'ログアウト'
        end
        it 'should succeed' do
          expect(RSpec.configuration.session[:user_id]).to be nil
        end
      end
    end
  end
end
