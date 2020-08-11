# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, assignee_id: user.id, reporter_id: user.id) }

  describe '#index' do
    before { visit project_tasks_path(task.project, task) }
    context 'when visit task index page' do
      it 'index page have' do
        expect(page).to have_content 'test_task'
        expect(page).to have_content '高'
        expect(page).to have_content '期限日'
        expect(page).to have_content '修正'
        expect(page).to have_content '削除'
      end
    end

    context 'when first visit index page' do
      let!(:task_1) { create(:task, task_name: 'pre_task', project_id: task.project_id, created_at: '2020-08-05', assignee_id: user.id, reporter_id: user.id) }
      let!(:task_2) { create(:task, task_name: 'cur_task', project_id: task.project_id, created_at: '2020-08-06', assignee_id: user.id, reporter_id: user.id) }

      it 'tasks order by created_at' do
        visit project_tasks_path(task.project, task)
        expect(page.body.index(task_2.task_name)).to be < page.body.index(task_1.task_name)
      end
    end

    context 'when task list change order' do
      let!(:task_1) { create(:task, task_name: 'pre_task', project_id: task.project_id, finished_at: '2020-08-05', assignee_id: user.id, reporter_id: user.id) }
      let!(:task_2) { create(:task, task_name: 'cur_task', project_id: task.project_id, finished_at: '2020-08-06', assignee_id: user.id, reporter_id: user.id) }

      it 'tasks order by finished_at desc' do
        select I18n.t('tasks.search.order.desc_finished_at'), from: 'order_by'
        click_on I18n.t('tasks.search.sort_button')

        expect(page.body.index(task_2.finished_at.to_s)).to be < page.body.index(task_1.finished_at.to_s)
      end

      it 'tasks order by finished_at asc' do
        select I18n.t('tasks.search.order.asc_finished_at'), from: 'order_by'
        click_on I18n.t('tasks.search.sort_button')

        expect(page.body.index(task_1.finished_at.to_s)).to be < page.body.index(task_2.finished_at.to_s)
      end
    end
  end

  describe '#new' do
    before { visit new_project_task_path(task.project) }
    context 'when create task' do
      it 'task was created' do
        fill_in 'task_task_name', with: 'add_task'
        fill_in 'task_description', with: 'add_description'
        select '中', from: 'task_priority'
        fill_in 'task_started_at', with: Time.zone.parse('07/12/2020')
        fill_in 'task_finished_at', with: Time.zone.parse('07/12/2020')
        select task.assignee.account_name, from: 'task_assignee_id'
        select task.reporter.account_name, from: 'task_reporter_id'

        click_on '登録する'
        expect(page).to have_content 'タスクが作成されました。'
        expect(Task.find_by(task_name: 'add_task'))
      end
    end

    context 'when task create to check validation' do
      it 'error new task' do
        fill_in 'task_description', with: 'add_description'
        select '中', from: 'task_priority'

        click_on '登録する'
        expect(page).to have_content 'タスク名を入力してください'
        expect(page).to have_content '開始日を入力してください'
        expect(page).to have_content '終了日を入力してください'
      end
    end
  end

  describe '#show' do
    context 'when show page enter' do
      it 'check task detail page' do
        visit project_task_path(task.project, task)

        expect(page).to have_content 'PJ_Factory'
        expect(page).to have_content 'test_discription'
        expect(page).to have_content '高'
        expect(page).to have_content 'user_7'
        expect(page).to have_content 'user_7'
        expect(page).to have_content '2020-08-01'
        expect(page).to have_content '2020-08-05'
      end
    end
  end

  describe '#edit' do
    before { visit edit_project_task_path(task.project, task) }
    context 'when task edit' do
      it 'edit task' do
        fill_in 'task_task_name', with: 'edit_task'
        fill_in 'task_description', with: 'edit_description'
        select '高', from: 'task_priority'
        fill_in 'task_started_at', with: Time.zone.parse('10/12/2020')
        fill_in 'task_finished_at', with: Time.zone.parse('15/12/2020')
        select task.assignee.account_name, from: 'task_assignee_id'
        select task.reporter.account_name, from: 'task_reporter_id'

        click_on '更新する'
        expect(page).to have_content 'タスクが更新されました。'
        expect(Task.find_by(task_name: 'edit_task'))
      end
    end

    context 'when task edit to check validation' do
      it 'error new task' do
        fill_in 'task_task_name', with: ''
        fill_in 'task_description', with: 'edit_description'
        select '高', from: 'task_priority'
        fill_in 'task_started_at', with: ''
        fill_in 'task_finished_at', with: ''

        click_on '更新する'
        expect(page).to have_content 'タスク名を入力してください'
        expect(page).to have_content '開始日を入力してください'
        expect(page).to have_content '終了日を入力してください'
      end
    end
  end

  describe '#delete' do
    context 'when task delete' do
      it 'delete task' do
        visit project_tasks_path(task.project, task)

        click_link '削除', href: project_task_path(task.project, task.id)
        expect(page.driver.browser.switch_to.alert.text).to eq '削除してもよろしいでしょうか?'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'タスクが削除されました。'
      end
    end
  end
end
