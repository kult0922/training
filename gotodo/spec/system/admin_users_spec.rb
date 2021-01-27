# frozen_string_literal: true

require 'rails_helper'
require 'pp'

RSpec.describe 'AdminUsers', type: :system do
  let!(:admin_role) { FactoryBot.create(:role, :admin) }
  let!(:editor_role) { FactoryBot.create(:role, :editor) }
  let!(:login_user) { FactoryBot.create(:user, name: '夏目', email: 'natsume@example.com', role: admin_role) }
  subject { page }

  before 'ログイン' do
    visit login_path
    fill_in 'email', with: login_user.email
    fill_in 'password', with: login_user.password
    click_button 'ログイン'
  end

  describe 'アクセス権' do
    context 'ログイン状態の時' do
      it '#indexにアクセスできること' do
        visit admin_users_path
        is_expected.to have_current_path admin_users_path
      end
    end

    context '未ログイン状態の時' do
      before do
        click_link nil, href: logout_path
      end
      it '#indexにアクセスできないこと' do
        visit admin_users_path
        is_expected.to have_current_path login_path
      end
    end
  end

  describe '#index (/admin/users)' do
    shared_examples '期待した順番で表示されること' do
      it do
        users_list = all('tbody tr')
        expected_list.each_with_index do |user, i|
          expect(users_list[i].all('td')[1].text).to eq user.email
        end
      end
    end

    describe '表示項目' do
      it '期待した項目が表示されること' do
        visit admin_users_path
        is_expected.to have_content login_user.name
        is_expected.to have_content login_user.email
        is_expected.to have_content login_user.created_at.strftime('%Y/%m/%d %H:%M:%S')
        is_expected.to have_content login_user.updated_at.strftime('%Y/%m/%d %H:%M:%S')
      end
    end

    describe 'ソート機能' do
      describe 'ユーザ名' do
        let!(:other_user) { FactoryBot.create(:user, name: '1田沼', email: 'tanuma@example.com', role: editor_role) }
        let!(:user2) { FactoryBot.create(:user, name: '2多軌', email: 'taki@example.com', role: editor_role) }
        let!(:user3) { FactoryBot.create(:user, name: '3ニャンコ先生', email: 'nyanko@example.com', role: editor_role) }
        context '昇順' do
          before do
            visit admin_users_path
            click_link nil, id: 'name_asc'
          end
          let(:expected_list) { [other_user, user2, user3, login_user] }
          it_behaves_like '期待した順番で表示されること'
        end
        context '降順' do
          before do
            visit admin_users_path
            click_link nil, id: 'name_desc'
          end
          let(:expected_list) { [login_user, user3, user2, other_user] }
          it_behaves_like '期待した順番で表示されること'
        end
      end

      describe 'メールアドレス' do
        let!(:user1) { FactoryBot.create(:user, email: 'tanuma@example.com', role: editor_role) }
        let!(:user2) { FactoryBot.create(:user, email: 'taki@example.com', role: editor_role) }
        let!(:user3) { FactoryBot.create(:user, email: 'nyanko@example.com', role: editor_role) }
        context '昇順' do
          before do
            visit admin_users_path
            click_link nil, id: 'email_asc'
          end
          let(:expected_list) { [login_user, user3, user2, user1] }
          it_behaves_like '期待した順番で表示されること'
        end
        context '降順' do
          before do
            visit admin_users_path
            click_link nil, id: 'email_desc'
          end
          let(:expected_list) { [user1, user2, user3, login_user] }
          it_behaves_like '期待した順番で表示されること'
        end
      end

      describe 'タスク数' do
        let!(:user1) { FactoryBot.create(:user, email: 'tanuma@example.com', role: editor_role) }
        let!(:user2) { FactoryBot.create(:user, email: 'taki@example.com', role: editor_role) }
        let!(:user3) { FactoryBot.create(:user, email: 'nyanko@example.com', role: editor_role) }
        let!(:task1) { FactoryBot.create(:task, user: login_user) }
        let!(:task2) { FactoryBot.create(:task, user: user1) }
        let!(:task3) { FactoryBot.create(:task, user: user2) }
        let!(:task4) { FactoryBot.create(:task, user: user2) }
        context '昇順' do
          before do
            visit admin_users_path
            click_link nil, id: 'tasks_count_asc'
          end
          let(:expected_list) { [user3, user1, login_user, user2] }
          it_behaves_like '期待した順番で表示されること'
        end
        context '降順' do
          before do
            visit admin_users_path
            click_link nil, id: 'tasks_count_desc'
          end
          let(:expected_list) { [user2, user1, login_user, user3] }
          it_behaves_like '期待した順番で表示されること'
        end
      end

      describe '作成日時' do
        let!(:user1) { FactoryBot.create(:user, email: 'tanuma@example.com', created_at: Time.current + 1.day, role: editor_role) }
        let!(:user2) { FactoryBot.create(:user, email: 'taki@example.com', created_at: Time.current + 3.days, role: editor_role) }
        let!(:user3) { FactoryBot.create(:user, email: 'nyanko@example.com', created_at: Time.current + 2.days, role: editor_role) }
        context '昇順' do
          before do
            visit admin_users_path
            click_link nil, id: 'created_at_asc'
          end
          let(:expected_list) { [login_user, user1, user3, user2] }
          it_behaves_like '期待した順番で表示されること'
        end
        context '降順' do
          before do
            visit admin_users_path
            click_link nil, id: 'created_at_desc'
          end
          let(:expected_list) { [user2, user3, user1, login_user] }
          it_behaves_like '期待した順番で表示されること'
        end
      end

      describe '更新日時' do
        let!(:user1) { FactoryBot.create(:user, email: 'tanuma@example.com', updated_at: Time.current + 1.day, role: editor_role) }
        let!(:user2) { FactoryBot.create(:user, email: 'taki@example.com', updated_at: Time.current + 3.days, role: editor_role) }
        let!(:user3) { FactoryBot.create(:user, email: 'nyanko@example.com', updated_at: Time.current + 2.days, role: editor_role) }
        context '昇順' do
          before do
            visit admin_users_path
            click_link nil, id: 'updated_at_asc'
          end
          let(:expected_list) { [login_user, user1, user3, user2] }
          it_behaves_like '期待した順番で表示されること'
        end
        context '降順' do
          before do
            visit admin_users_path
            click_link nil, id: 'updated_at_desc'
          end
          let(:expected_list) { [user2, user3, user1, login_user] }
          it_behaves_like '期待した順番で表示されること'
        end
      end
    end
  end

  describe 'users#edit(users_id) [/users/*users_id*/edit]' do
    let!(:other_user) { FactoryBot.create(:user, email: 'tanuma@example.com', role: editor_role) }
    let(:edited_user) {
      {
        'name' => '的場',
        'email' => 'matoba@example.com',
        'role' => admin_role,
        'password' => 'matoba',
      }
    }

    describe '自分の情報を更新する' do
      before do
        visit edit_user_path(other_user.id)
      end

      shared_examples 'ユーザ詳細画面に遷移すること' do
        it do
          is_expected.to have_current_path user_path(other_user)
          is_expected.to have_selector('.alert-success', text: 'ユーザが更新されました！')
        end
      end

      context 'パスワードのみ更新する' do
        before do
          fill_in 'user[password]', with: edited_user['password']
          fill_in 'user[password_confirmation]', with: edited_user['password']
          click_button '更新する'
        end

        it_behaves_like 'ユーザ詳細画面に遷移すること'

        it 'パスワード以外の情報が書き換わっていないこと' do
          expect(find('#user_name').value).to eq other_user.name
          expect(find('#user_email').value).to eq other_user.email
          expect(find('#user_role_id').value.to_i).to eq other_user.role.id
        end

        it '元々のメールアドレスと更新したパスワードでログインできること' do
          click_link nil, href: logout_path

          is_expected.to have_current_path login_path
          fill_in 'email', with: other_user.email
          fill_in 'password', with: edited_user['password']
          click_button 'ログイン'

          is_expected.to have_current_path root_path
          is_expected.to have_selector('.alert-success', text: "ようこそ、#{other_user.name}さん")
        end
      end

      context 'パスワード以外を更新する' do
        before do
          fill_in 'user[name]', with: edited_user['name']
          fill_in 'user[email]', with: edited_user['email']
          find('#user_role_id').find("option[value=#{edited_user['role'].id}]").select_option
          click_button '更新する'
        end

        it_behaves_like 'ユーザ詳細画面に遷移すること'

        it '情報が更新されていること' do
          expect(find('#user_name').value).to eq edited_user['name']
          expect(find('#user_email').value).to eq edited_user['email']
          expect(find('#user_role_id').value.to_i).to eq edited_user['role'].id
        end

        it '更新したメールアドレスと元々のパスワードでログインできること' do
          click_link nil, href: logout_path

          is_expected.to have_current_path login_path
          fill_in 'email', with: edited_user['email']
          fill_in 'password', with: other_user.password
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

        it_behaves_like 'ユーザ詳細画面に遷移すること'

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

  describe '#destroy(user_id)' do
    let!(:other_user) { FactoryBot.create(:user, email: 'tanuma@example.com', role: editor_role) }
    let!(:user2) { FactoryBot.create(:user, email: 'taki@example.com', role: editor_role) }
    let!(:task1) { FactoryBot.create(:task, user: login_user) }
    let!(:task2) { FactoryBot.create(:task, user: other_user) }
    let!(:task3) { FactoryBot.create(:task, user: user2) }
    let!(:task4) { FactoryBot.create(:task, user: user2) }

    it '削除したユーザが表示されず、削除していないユーザが表示されること' do
      visit admin_users_path
      click_link nil, href: user_path(other_user), class: 'delete-link'
      is_expected.to have_current_path admin_users_path
      is_expected.to have_selector('.alert-success', text: 'ユーザが削除されました！')
      is_expected.to have_no_content other_user.email
      is_expected.to have_content login_user.email
      is_expected.to have_content user2.email
    end

    it 'ユーザを削除すると、関連したタスクも削除されること' do
      expect { user2.destroy }.to change { Task.count }.by(-2)
    end
  end
end
