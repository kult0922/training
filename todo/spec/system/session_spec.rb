require 'rails_helper'

describe '#session', type: :system do
  let!(:user) { create(:user) }

  describe '#login' do
    before { visit login_path }
    
    context 'when user id is not exist' do
      it 'should be login error' do
        fill_in 'session_account_name', with: 'monolla'
        fill_in 'session_password', with: 'testtest'
        click_on 'ログイン'
        expect(page).to have_content 'ログイン失敗'
      end
    end

    context 'when user password is not invalid' do
      it 'should be login error' do
        fill_in 'session_account_name', with: 'factoryUser1'
        fill_in 'session_password', with: 'testpassword'
        click_on 'ログイン'
        expect(page).to have_content 'ログイン失敗'
      end
    end

    context 'when user id, password is valid' do
      it 'should be login success' do
        fill_in 'session_account_name', with: 'factoryUser3'
        fill_in 'session_password', with: 'testtest'
        click_on 'ログイン'
        expect(page).to have_content 'factoryUser3'
        expect(page).to have_content 'タスク管理アプリ'
      end
    end
  end
end