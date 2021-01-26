# frozen_string_literal: true

require 'rails_helper'
require 'pp'

RSpec.describe 'Users', type: :system do
  let!(:login_user) { FactoryBot.create(:user) }
  subject { page }

  before 'ログイン' do
    visit login_path
    fill_in 'email', with: login_user.email
    fill_in 'password', with: login_user.password
    click_button 'ログイン'
  end

  describe 'アクセス権' do
    context 'ログイン状態の時' do
      it '#newにアクセスできること' do
        visit new_user_path
        is_expected.to have_current_path new_user_path
      end
    end

    context '未ログイン状態の時' do
      before do
        click_link nil, href: logout_path
      end
      it '#newにアクセスできること' do
        visit new_user_path
        is_expected.to have_current_path new_user_path
      end
    end
  end

  describe '#new' do
    let(:new_user) {
      {
        'name' => 'ニャンコ先生',
        'email' => 'nyanko@example.com',
        'password' => 'xxx',
        'password_confirmation' => 'xxx',
      }
    }
    before do
      visit new_user_path
      fill_in 'user[name]', with: new_user['name']
      fill_in 'user[email]', with: new_user['email']
      fill_in 'user[password]', with: new_user['password']
      fill_in 'user[password_confirmation]', with: new_user['password_confirmation']
      click_button '登録する'
    end

    it '新規作成したユーザでログインできること' do
      is_expected.to have_current_path root_path
      is_expected.to have_selector('.alert-success', text: '新しいユーザが登録されました！')
      click_link nil, href: logout_path

      is_expected.to have_current_path login_path
      fill_in 'email', with: new_user['email']
      fill_in 'password', with: new_user['password']
      click_button 'ログイン'

      is_expected.to have_current_path root_path
      is_expected.to have_selector('.alert-success', text: "ようこそ、#{new_user['name']}さん")
    end
  end

  describe '#edit(user_id)' do
    let(:edited_user) {
      {
        'name' => '夏目',
        'email' => 'natsume@example.com',
        'password' => 'natsume'
      } }

    context 'パスワードのみ更新する' do
      before do
        visit edit_user_path login_user.id
        fill_in 'user[password]', with: edited_user['password']
        fill_in 'user[password_confirmation]', with: edited_user['password']
        click_button '更新する'
      end

      it 'パスワード以外の情報が書き換わっていないこと' do
        is_expected.to have_current_path profile_path
        expect(find('#user_name').value).to eq login_user.name
        expect(find('#user_email').value).to eq login_user.email
        is_expected.to have_selector('.alert-success', text: 'ユーザが更新されました！')
      end

      it '元々のメールアドレスと更新したパスワードでログインできること' do
        is_expected.to have_current_path profile_path
        is_expected.to have_selector('.alert-success', text: 'ユーザが更新されました！')
        click_link nil, href: logout_path

        is_expected.to have_current_path login_path
        fill_in 'email', with: login_user.email
        fill_in 'password', with: edited_user['password']
        click_button 'ログイン'

        is_expected.to have_current_path root_path
        is_expected.to have_selector('.alert-success', text: "ようこそ、#{login_user.name}さん")
      end
    end

    context 'パスワード以外を更新する' do
      before do
        visit edit_user_path login_user.id
        fill_in 'user[name]', with: edited_user['name']
        fill_in 'user[email]', with: edited_user['email']
        click_button '更新する'
      end

      it '情報が更新されていること' do
        is_expected.to have_current_path profile_path
        expect(find('#user_name').value).to eq edited_user['name']
        expect(find('#user_email').value).to eq edited_user['email']
        is_expected.to have_selector('.alert-success', text: 'ユーザが更新されました！')
      end

      it '更新したメールアドレスと元々のパスワードでログインできること' do
        is_expected.to have_current_path profile_path
        is_expected.to have_selector('.alert-success', text: 'ユーザが更新されました！')
        click_link nil, href: logout_path

        is_expected.to have_current_path login_path
        fill_in 'email', with: edited_user['email']
        fill_in 'password', with: login_user.password
        click_button 'ログイン'

        is_expected.to have_current_path root_path
        is_expected.to have_selector('.alert-success', text: "ようこそ、#{edited_user['name']}さん")
      end
    end

    context 'すべて更新する' do
      before do
        visit edit_user_path login_user.id
        fill_in 'user[name]', with: edited_user['name']
        fill_in 'user[email]', with: edited_user['email']
        fill_in 'user[password]', with: edited_user['password']
        fill_in 'user[password_confirmation]', with: edited_user['password']
        click_button '更新する'
      end

      it '情報が更新されていること' do
        is_expected.to have_current_path profile_path
        expect(find('#user_name').value).to eq edited_user['name']
        expect(find('#user_email').value).to eq edited_user['email']
        is_expected.to have_selector('.alert-success', text: 'ユーザが更新されました！')
      end

      it '更新したメールアドレスとパスワードでログインできること' do
        is_expected.to have_current_path profile_path
        is_expected.to have_selector('.alert-success', text: 'ユーザが更新されました！')
        click_link nil, href: logout_path

        is_expected.to have_current_path login_path
        fill_in 'email', with: edited_user['email']
        fill_in 'password', with: edited_user['password']
        click_button 'ログイン'

        is_expected.to have_current_path root_path
        is_expected.to have_selector('.alert-success', text: "ようこそ、#{edited_user['name']}さん")
      end
    end

  end
end
