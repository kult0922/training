# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, assignee_id: user.id, reporter_id: user.id) }

  describe '#index' do
    it 'visit task index page' do
      visit tasks_path(project_id: task.project.id)

      expect(page).to have_content 'test_task'
      expect(page).to have_content '高'
      expect(page).to have_content '期限日'
      expect(page).to have_content '修正'
      expect(page).to have_content '削除'
    end

    it 'task sorder by created_at' do
      tasks = create_list(:task, 2, :order_by_created_at, assignee_id: user.id, reporter_id: user.id)

      visit tasks_path(project_id: task.project.id)

      # tasks[1]はtasks[0]より1日前の日付
      expect(tasks[1].created_at < tasks[0].created_at).to be true
      expect(page.body.index(tasks[1].task_name)).to be < page.body.index(tasks[0].task_name)
    end
  end

  describe '#new' do
    before do
      visit new_task_path(project_id: task.project.id)

      fill_in 'task_task_name', with: 'add_task'
      fill_in 'task_description', with: 'add_description'
      select '中', from: 'task_priority'
      fill_in 'task_started_at', with: Time.zone.parse('07/12/2020')
      fill_in 'task_finished_at', with: Time.zone.parse('07/12/2020')
      select task.assignee.account_name, from: 'task_assignee_id'
      select task.reporter.account_name, from: 'task_reporter_id'
    end

    it 'Create new task' do
      click_on '登録する'
      expect(page).to have_content 'タスクが作成されました。'
      expect(Task.find_by(task_name: 'add_task'))
    end
  end

  describe '#show' do
    it 'check task detail page' do
      visit task_path(task.id, project_id: task.project.id)
      expect(page).to have_content 'test_task'
      expect(page).to have_content 'test_discription'
      expect(page).to have_content '高'
      expect(page).to have_content 'user_4'
      expect(page).to have_content 'user_4'
      expect(page).to have_content '2020-08-01'
      expect(page).to have_content '2020-08-05'
    end
  end

  describe '#edit' do
    before do
      visit edit_task_path(task.id, project_id: task.project.id)

      fill_in 'task_task_name', with: 'edit_task'
      fill_in 'task_description', with: 'edit_description'
      select '高', from: 'task_priority'
      fill_in 'task_started_at', with: Time.zone.parse('10/12/2020')
      fill_in 'task_finished_at', with: Time.zone.parse('15/12/2020')
      select task.assignee.account_name, from: 'task_assignee_id'
      select task.reporter.account_name, from: 'task_reporter_id'
    end

    it 'edit task' do
      click_on '更新する'
      expect(page).to have_content 'タスクが更新されました。'
      expect(Task.find_by(task_name: 'edit_task'))
    end
  end

  describe '#delete' do
    before do
      visit tasks_path(project_id: task.project.id)
    end
    it 'delete task' do
      click_link '削除', href: task_path(task.id)
      expect(page.driver.browser.switch_to.alert.text).to eq '削除してもよろしいでしょうか?'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'タスクが削除されました。'
    end
  end

  describe '#new error' do
    before do
      visit new_task_path(project_id: task.project.id)

      fill_in 'task_description', with: 'add_description'
      select '中', from: 'task_priority'
    end

    it 'error new task' do
      click_on '登録する'
      expect(page).to have_content 'タスク名を入力してください'
      expect(page).to have_content '開始日を入力してください'
      expect(page).to have_content '終了日を入力してください'
    end
  end

  describe '#edit error' do
    before do
      visit edit_task_path(task.id, project_id: task.project.id)

      fill_in 'task_task_name', with: ''
      fill_in 'task_description', with: 'edit_description'
      select '高', from: 'task_priority'
      fill_in 'task_started_at', with: ''
      fill_in 'task_finished_at', with: ''
    end

    it 'error new task' do
      click_on '更新する'
      expect(page).to have_content 'タスク名を入力してください'
      expect(page).to have_content '開始日を入力してください'
      expect(page).to have_content '終了日を入力してください'
    end
  end
end
