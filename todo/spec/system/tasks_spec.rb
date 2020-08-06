# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, assignee_id: user.id, reporter_id: user.id) }

  describe '#index' do
    context 'when task index page' do
      before do
        visit tasks_path(project_id: task.project.id)
      end

      it 'index page have' do
      expect(page).to have_content 'test_task'
      expect(page).to have_content '高'
      expect(page).to have_content '期限日'
      expect(page).to have_content '完了'
      expect(page).to have_content '修正'
      expect(page).to have_content '削除'
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
        visit tasks_path(project_id: task.project.id)
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
        visit tasks_path(project_id: task.project.id)
        fill_in 'task_name_input', with: 'my'
        click_on I18n.t('tasks.search.button')
  
        expect(page).to have_content 'mywork1'
        expect(page).to have_content 'mywork2'
        expect(page).to have_no_content 'your work1'
        expect(page).to have_no_content 'your work2'
        expect(page).to have_no_content 'your work3'
  
        fill_in 'task_name_input', with: 'your'
        click_on I18n.t('tasks.search.button')
  
        expect(page).to have_no_content 'mywork1'
        expect(page).to have_no_content 'mywork2'
        expect(page).to have_content 'your work1'
        expect(page).to have_content 'your work2'
        expect(page).to have_content 'your work3'
      end
  
      it 'tasks search priority' do
        visit tasks_path(project_id: task.project.id)
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
        visit tasks_path(project_id: task.project.id)
        fill_in 'task_name_input', with: 'your'
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
      let!(:pre_created_task) { create(:task, task_name: 'pre_create_task', project_id: task.project_id, created_at: "2020-08-05", assignee_id: user.id, reporter_id: user.id) }
      let!(:cur_created_task) { create(:task, task_name: 'cur_create_task', project_id: task.project_id, created_at: "2020-08-06", assignee_id: user.id, reporter_id: user.id) }

      before do
        visit tasks_path(project_id: task.project.id)
      end

      it 'tasks order by created_at' do
        expect(page.body.index(cur_created_task.task_name)).to be < page.body.index(pre_created_task.task_name)
      end
    end

    context 'when task list change order' do
      let!(:pre_finished_task) { create(:task, task_name: 'pre_finished_task', project_id: task.project_id, finished_at: "2020-08-05", assignee_id: user.id, reporter_id: user.id) }
      let!(:cur_finished_task) { create(:task, task_name: 'cur_finished_task', project_id: task.project_id, finished_at: "2020-08-06", assignee_id: user.id, reporter_id: user.id) }
      
      before do
        visit tasks_path(project_id: task.project_id)
      end

      it 'tasks order by finished_at desc' do
        
        # order by finished_at desc
        select I18n.t('tasks.search.order.desc_finished_at'), from: 'order_by'
        click_on I18n.t('tasks.search.button')

        expect(page.body.index(cur_finished_task.finished_at.to_s)).to be < page.body.index(pre_finished_task.finished_at.to_s)
      end
    
      it 'tasks order by finished_at asc' do
        tasks = create_list(:task, 2, :order_by_finished_at, assignee_id: user.id, reporter_id: user.id)

        # order by finished_at asc
        select I18n.t('tasks.search.order.asc_finished_at'), from: 'order_by'
        click_on I18n.t('tasks.search.button')

        expect(page.body.index(pre_finished_task.finished_at.to_s)).to be < page.body.index(cur_finished_task.finished_at.to_s)
      end
    end
  end

  describe '#new' do
    context 'when create task' do
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

    context 'when task create to check validation'
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

  describe '#show' do
    context 'when show page enter' do
      before do
        visit task_path(task.id, project_id: task.project.id)
      end
      it 'check task detail page' do
        expect(page).to have_content 'PJ_Factory'
        expect(page).to have_content 'test_discription'
        expect(page).to have_content '高'
        expect(page).to have_content 'user_11'
        expect(page).to have_content 'user_11'
        expect(page).to have_content task.started_at
        expect(page).to have_content task.finished_at
      end
    end
  end

  describe '#edit' do
    context 'when task edit' do
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

    context 'when task edit to check validation' do
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

  describe '#delete' do
    context 'when task delete' do
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
