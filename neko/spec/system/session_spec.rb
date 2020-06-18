require 'rails_helper'

describe 'session', type: :system do
  let!(:user1) { create(:user, name: 'user1') }
  let!(:auth1) { create(:auth, user: user1) }
  before { visit '/login' }

  describe '#login' do
    context 'enter invailed email' do
      it 'should be failure to login' do
        fill_in 'Email', with: 'wrong@example.com'
        fill_in 'Password', with: 'testpassword'
        click_on 'ログイン'
        expect(page).to have_current_path login_path
        expect(page).to have_content 'ログインに失敗しました'
      end
    end

    context 'enter invailed email' do
      it 'should be failure to login' do
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'wrongpassword'
        click_on 'ログイン'
        expect(page).to have_current_path login_path
        expect(page).to have_content 'ログインに失敗しました'
      end
    end

    context 'enter vailed email & password' do
      it 'should be success to login' do
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'testpassword'
        click_on 'ログイン'
        expect(page).to have_current_path root_path
        expect(page).to have_content 'ログインしました'
      end
    end
  end

  describe '#logout' do
    context "click 'logout'" do
      it 'should be success to logout' do
        fill_in 'Email', with: 'test@example.com'
        fill_in 'Password', with: 'testpassword'
        click_on 'ログイン'
        expect(page).to have_current_path '/'
        click_on 'ログアウト'
        expect(page).to have_current_path login_path
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end
end
