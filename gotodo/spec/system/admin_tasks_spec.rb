# frozen_string_literal: true

require 'rails_helper'
require 'pp'

RSpec.describe 'AdminTasks', type: :system do
  let!(:admin_role) { FactoryBot.create(:role, :admin) }
  let!(:login_user) { FactoryBot.create(:user, email: 'natsume@example.com', role: admin_role) }
  let!(:user1) { FactoryBot.create(:user, email: 'tanuma@example.com', role: admin_role) }
  let!(:task1) { FactoryBot.create(:task, user: user1) }
  subject { page }

  before 'ログイン' do
    visit login_path
    fill_in 'email', with: login_user.email
    fill_in 'password', with: login_user.password
    click_button 'ログイン'
  end

  describe '#index [admin/users/*user_id*/tasks]' do
    describe '他人のタスクを編集する' do
      let(:edited_task) { { 'title' => '買い物に行く' } }

      it 'タスクが編集され、他人のタスクのままであること' do
        visit admin_users_path
        click_link('1', { href: tasks_admin_user_path(user1) })
        click_link(nil, { href: edit_task_path(task1), class: 'edit-link' })

        fill_in 'task[title]', with: edited_task['title']
        click_button '更新する'

        is_expected.to have_current_path task_path(task1.id)
        expect(find('#task_title').value).to eq edited_task['title']
        is_expected.to have_selector('.alert-success', text: 'タスクが更新されました！')

        visit admin_users_path
        click_link('1', { href: tasks_admin_user_path(user1) })
        is_expected.to have_content edited_task['title']
      end
    end
  end

  describe '#destroy(task_id) [admin/users/*user_id*/tasks]' do
    describe '他人のタスクを削除する' do
      it '削除したタスクが表示されないこと' do
        visit admin_users_path
        click_link('1', { href: tasks_admin_user_path(user1) })
        click_link nil, href: task_path(task1), class: 'delete-link'

        is_expected.to have_current_path tasks_admin_user_path(user1)
        is_expected.to have_selector('.alert-success', text: 'タスクが削除されました！')
        is_expected.to have_no_content task1.title
      end
    end
  end
end
