# frozen_string_literal: true

require 'rails_helper'
require 'pp'

RSpec.describe 'Users', type: :system do
  let!(:admin_role) { FactoryBot.create(:role, :admin) }
  let!(:editor_role) { FactoryBot.create(:role, :editor) }
  let!(:login_user) { FactoryBot.create(:user, email: 'login@example.com', role: admin_role) }
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

  describe '#show(user_id)' do
    describe 'ページ遷移' do
      it '戻るボタンでトップ画面に遷移すること' do
        visit profile_path
        click_link nil, class: 'back-link'
        is_expected.to have_current_path root_path
      end
      it '編集ボタンで編集画面に遷移すること' do
        visit profile_path
        click_link nil, class: 'edit-link'
        is_expected.to have_current_path profile_edit_path
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
        'role' => admin_role,
      }
    }
    before do
      visit new_user_path
      fill_in 'user[name]', with: new_user['name']
      fill_in 'user[email]', with: new_user['email']
      fill_in 'user[password]', with: new_user['password']
      fill_in 'user[password_confirmation]', with: new_user['password_confirmation']
      find('#user_role_id').find("option[value=#{new_user['role'].id}]").select_option
      click_button '登録する'
    end

    describe 'ページ遷移' do
      it '戻るボタンでログイン画面に遷移すること' do
        visit new_user_path
        click_link nil, class: 'back-link'
        is_expected.to have_current_path login_path
      end
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
        'name' => '的場',
        'email' => 'matoba@example.com',
        'password' => 'matoba',
        'role' => admin_role,
      }
    }

    describe 'ページ遷移' do
      it '戻るボタンでプロフィール画面に遷移すること' do
        visit edit_user_path(login_user.id)
        click_link nil, class: 'back-link'
        is_expected.to have_current_path profile_path
      end
    end

    describe '自分の情報を更新する' do
      before do
        visit edit_user_path(login_user.id)
      end

      shared_examples 'プロフィール画面に遷移すること' do
        it do
          is_expected.to have_current_path profile_path
          is_expected.to have_selector('.alert-success', text: 'ユーザが更新されました！')
        end
      end

      context 'パスワードのみ更新する' do
        before do
          fill_in 'user[password]', with: edited_user['password']
          fill_in 'user[password_confirmation]', with: edited_user['password']
          click_button '更新する'
        end

        it_behaves_like 'プロフィール画面に遷移すること'

        it 'パスワード以外の情報が書き換わっていないこと' do
          expect(find('#user_name').value).to eq login_user.name
          expect(find('#user_email').value).to eq login_user.email
          expect(find('#user_role_id').value.to_i).to eq login_user.role.id
        end

        it '元々のメールアドレスと更新したパスワードでログインできること' do
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
          fill_in 'user[name]', with: edited_user['name']
          fill_in 'user[email]', with: edited_user['email']
          find('#user_role_id').find("option[value=#{edited_user['role'].id}]").select_option
          click_button '更新する'
        end

        it_behaves_like 'プロフィール画面に遷移すること'

        it '情報が更新されていること' do
          expect(find('#user_name').value).to eq edited_user['name']
          expect(find('#user_email').value).to eq edited_user['email']
          expect(find('#user_role_id').value.to_i).to eq edited_user['role'].id
        end

        it '更新したメールアドレスと元々のパスワードでログインできること' do
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
          fill_in 'user[name]', with: edited_user['name']
          fill_in 'user[email]', with: edited_user['email']
          find('#user_role_id').find("option[value=#{edited_user['role'].id}]").select_option
          fill_in 'user[password]', with: edited_user['password']
          fill_in 'user[password_confirmation]', with: edited_user['password']
          click_button '更新する'
        end

        it_behaves_like 'プロフィール画面に遷移すること'

        it '情報が更新されていること' do
          expect(find('#user_name').value).to eq edited_user['name']
          expect(find('#user_email').value).to eq edited_user['email']
          expect(find('#user_role_id').value.to_i).to eq edited_user['role'].id
        end

        it '更新したメールアドレスとパスワードでログインできること' do
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
end
