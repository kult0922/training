require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  let!(:user) { create(:user) }

  before { visit login_path }

  describe '#create' do
    context 'ログインした場合' do
      context '正しい認証情報を入力した場合' do
        it 'タスク一覧画面に遷移する' do
          fill_in 'session_mail_address', with: user.mail_address
          fill_in 'session_password', with: 'pAssw0rd'
          click_button 'ログイン'
          expect(page).to have_current_path '/'
          expect(page).to have_content 'ログインに成功しました'
        end
      end

      context '誤った認証情報を入力した場合' do
        context '誤ったメールアドレスを入力した場合' do
          it 'ログインに失敗する' do
            fill_in 'session_mail_address', with: 'wrong_mail_address@example.com'
            fill_in 'session_password', with: 'pAssw0rd'
            click_button 'ログイン'
            expect(page).to have_current_path '/login'
            expect(page).to have_content 'ログインに失敗しました'
          end
        end

        context '誤ったパスワードを入力した場合' do
          it 'ログインに失敗する' do
            fill_in 'session_mail_address', with: user.mail_address
            fill_in 'session_password', with: 'wrong_password'
            click_button 'ログイン'
            expect(page).to have_current_path '/login'
            expect(page).to have_content 'ログインに失敗しました'
          end
        end
      end
    end
  end

  describe '#destroy' do
    context 'ログアウトした場合' do
      it 'ログイン画面に遷移する' do
        fill_in 'session_mail_address', with: user.mail_address
        fill_in 'session_password', with: 'pAssw0rd'
        click_button 'ログイン'
        click_link 'ログアウト'
        expect(page).to have_current_path '/login'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end
end
