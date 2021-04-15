# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Labels', type: :system do
  let!(:user) { create(:user, role_id: 'member') }
  let!(:label) { create(:label, user_id: user.id) }

  describe 'update' do
    context 'logging in' do
      before 'login' do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: user.password
        click_button 'ログイン'
      end

      it 'success' do
        visit edit_label_path(label)

        fill_in 'label_name', with: 'sample'
        click_button '更新する'

        expect(page).to have_content 'sample'
      end
    end
  end

  describe 'destroy' do
    context 'logging in' do
      before 'login' do
        visit login_path
        fill_in 'email', with: user.email
        fill_in 'password', with: user.password
        click_button 'ログイン'
      end

      it 'success' do
        visit labels_path
        page.accept_confirm do
          click_on '削除', match: :first
        end
        expect(page).to have_content '成功しました。'
      end
    end
  end
end
