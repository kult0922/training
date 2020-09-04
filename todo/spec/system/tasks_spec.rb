# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, assignee_id: user.id, reporter_id: user.id) }
  let!(:label1) { create(:label, text: 'label_result') }
  let!(:label2) { create(:label, text: 'label_test') }

  describe '#index' do
    before do
      login(user)
      visit project_tasks_path(task.project, task)
    end

    context 'when visit task index page' do
      it 'index page have' do
        expect(page).to have_content 'test_task'
        expect(page).to have_content '高'
        expect(page).to have_content '期限日'
        expect(page).to have_content '修正'
        expect(page).to have_content '完了'
        expect(page).to have_content '削除'
      end
    end

    context 'when task have labels search' do
      let(:task1) { create(:task, assignee_id: user.id, reporter_id: user.id, task_name: 'label1', project_id: task.project_id) }
      let(:task2) { create(:task, assignee_id: user.id, reporter_id: user.id, task_name: 'label2', project_id: task.project_id) }
      let(:task3) { create(:task, assignee_id: user.id, reporter_id: user.id, task_name: 'label3', project_id: task.project_id) }

      before do
        TaskLabel.create(task_id: task1.id, label_id: label1.id)
        TaskLabel.create(task_id: task1.id, label_id: label2.id)
        TaskLabel.create(task_id: task2.id, label_id: label2.id)
        TaskLabel.create(task_id: task3.id, label_id: label1.id)
      end

      it 'have 2 contents' do
        visit project_tasks_path(task.project, task)
        check 'label_ids[]', match: :first
        click_on I18n.t('tasks.search.button')

        expect(page).to have_content 'label1'
        expect(page).to have_no_content 'label2'
        expect(page).to have_content 'label3'
      end
    end

    context 'when search do' do
      before do
        create(:task, project_id: task.project.id, assignee_id: user.id, reporter_id: user.id, task_name: 'mywork1', status: :todo, priority: :low)
        create(:task, project_id: task.project.id, assignee_id: user.id, reporter_id: user.id, task_name: 'mywork2', status: :in_progress, priority: :mid)
        create(:task, project_id: task.project.id, assignee_id: user.id, reporter_id: user.id, task_name: 'your work1', status: :done, priority: :high)
        create(:task, project_id: task.project.id, assignee_id: user.id, reporter_id: user.id, task_name: 'your work2', status: :in_progress, priority: :mid)
        create(:task, project_id: task.project.id, assignee_id: user.id, reporter_id: user.id, task_name: 'your work3', status: :todo, priority: :high)
      end

      it 'tasks search status' do
        select Task.human_attribute_name(:todo), from: 'status_search'
        click_on I18n.t('tasks.search.button')

        expect(page).to have_content 'mywork1'
        expect(page).to have_no_content 'mywork2'
        expect(page).to have_no_content 'your work1'
        expect(page).to have_no_content 'your work2'
        expect(page).to have_content 'your work3'

        select Task.human_attribute_name(:in_progress), from: 'status_search'
        click_on I18n.t('tasks.search.button')

        expect(page).to have_no_content 'mywork1'
        expect(page).to have_content 'mywork2'
        expect(page).to have_no_content 'your work1'
        expect(page).to have_content 'your work2'
        expect(page).to have_no_content 'your work3'

        select Task.human_attribute_name(:done), from: 'status_search'
        click_on I18n.t('tasks.search.button')

        expect(page).to have_no_content 'mywork1'
        expect(page).to have_no_content 'mywork2'
        expect(page).to have_content 'your work1'
        expect(page).to have_no_content 'your work2'
        expect(page).to have_no_content 'your work3'
      end

      it 'tasks search name' do
        fill_in 'name', with: 'my'
        click_on I18n.t('tasks.search.button')

        expect(page).to have_content 'mywork1'
        expect(page).to have_content 'mywork2'
        expect(page).to have_no_content 'your work1'
        expect(page).to have_no_content 'your work2'
        expect(page).to have_no_content 'your work3'

        fill_in 'name', with: 'your'
        click_on I18n.t('tasks.search.button')

        expect(page).to have_no_content 'mywork1'
        expect(page).to have_no_content 'mywork2'
        expect(page).to have_content 'your work1'
        expect(page).to have_content 'your work2'
        expect(page).to have_content 'your work3'
      end

      it 'tasks search priority' do
        select Task.human_attribute_name(:low), from: 'priority_search'
        click_on I18n.t('tasks.search.button')

        expect(page).to have_content 'mywork1'
        expect(page).to have_no_content 'mywork2'
        expect(page).to have_no_content 'your work1'
        expect(page).to have_no_content 'your work2'
        expect(page).to have_no_content 'your work3'

        select Task.human_attribute_name(:mid), from: 'priority_search'
        click_on I18n.t('tasks.search.button')

        expect(page).to have_no_content 'mywork1'
        expect(page).to have_content 'mywork2'
        expect(page).to have_no_content 'your work1'
        expect(page).to have_content 'your work2'
        expect(page).to have_no_content 'your work3'

        select Task.human_attribute_name(:high), from: 'priority_search'
        click_on I18n.t('tasks.search.button')

        expect(page).to have_no_content 'mywork1'
        expect(page).to have_no_content 'mywork2'
        expect(page).to have_content 'your work1'
        expect(page).to have_no_content 'your work2'
        expect(page).to have_content 'your work3'
      end

      it 'tasks multi search' do
        fill_in 'name', with: 'your'
        select Task.human_attribute_name(:in_progress), from: 'status_search'
        select Task.human_attribute_name(:mid), from: 'status_search'
        click_on I18n.t('tasks.search.button')

        expect(page).to have_no_content 'mywork1'
        expect(page).to have_no_content 'mywork2'
        expect(page).to have_no_content 'your work1'
        expect(page).to have_content 'your work2'
        expect(page).to have_no_content 'your work3'
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
        click_on I18n.t('tasks.search.button')

        expect(page.body.index(task_2.finished_at.to_s)).to be < page.body.index(task_1.finished_at.to_s)
      end
      it 'tasks order by finished_at asc' do
        select I18n.t('tasks.search.order.asc_finished_at'), from: 'order_by'
        click_on I18n.t('tasks.search.button')

        expect(page.body.index(task_1.finished_at.to_s)).to be < page.body.index(task_2.finished_at.to_s)
      end
    end
  end

  describe '#new' do
    before do
      login(user)
      visit new_project_task_path(task.project)
    end
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

    context 'when create task with labels' do
      it 'should be created with labels' do
        visit new_project_task_path(task.project)

        fill_in 'task_task_name', with: 'add_task'
        fill_in 'task_description', with: 'add_description'
        select '中', from: 'task_priority'
        fill_in 'task_started_at', with: Time.zone.parse('07/12/2020')
        fill_in 'task_finished_at', with: Time.zone.parse('07/12/2020')
        select task.assignee.account_name, from: 'task_assignee_id'
        select task.reporter.account_name, from: 'task_reporter_id'

        check 'task[label_ids][]', match: :first

        click_on '登録する'
        expect(page).to have_content 'タスクが作成されました。'
        expect(page).to have_content 'label_result'
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
    before { login(user) }
    context 'when show page enter' do
      it 'check task detail page' do
        visit project_task_path(task.project, task)

        expect(page).to have_content 'PJ_Factory'
        expect(page).to have_content 'test_discription'
        expect(page).to have_content '高'
        expect(page).to have_content user.account_name
        expect(page).to have_content user.account_name
        expect(page).to have_content '2020-06-01'
        expect(page).to have_content '2020-10-05'
      end
    end
  end

  describe '#edit' do
    before do
      login(user)
      visit edit_project_task_path(task.project, task)
    end
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
    before { login(user) }
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
