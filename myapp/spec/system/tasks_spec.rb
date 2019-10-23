require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  before do
    driven_by(:rack_test)
    @user = create(:user)
    @task1 = create(:task, created_at: DateTime.now)
    @task2 = create(:task, created_at: DateTime.now - 1)
    @task3 = create(:task, created_at: DateTime.now - 2)
  end

  context 'When a user opens task list' do
    it 'Success to show the list' do
      visit tasks_path

      expect(page).to have_content @task1.title
      expect(page).to have_content @task1.priority
      expect(page).to have_content @task1.status
      expect(page).to have_content @task1.due_date
      expect(page).to have_content I18n.l(@task1.created_at, format: :default)
      expect(page).to have_link I18n.t('operation.detail'), href: task_path(@task1.id)
      expect(page).to have_link I18n.t('operation.update'), href: edit_task_path(@task1.id)
      expect(page).to have_link I18n.t('operation.remove'), href: task_path(@task1.id)
    end

    it 'Task is sorted by created_at with descending order' do
      visit tasks_path

      title = page.all('.title')
      expect(title[0].text).to eq @task1.title
      expect(title[1].text).to eq @task2.title
      expect(title[2].text).to eq @task3.title
    end
  end

  context 'When a user opens task detail page' do
    it 'Success to see the task information' do
      visit task_path(@task1.id)

      expect(page).to have_content @task1.title
      expect(page).to have_content @task1.description
      expect(page).to have_content @task1.priority
      expect(page).to have_content @task1.due_date
      expect(page).to have_link I18n.t('operation.update'), href: edit_task_path(@task1.id)
      expect(page).to have_link I18n.t('operation.remove'), href: task_path(@task1.id)
      expect(page).to have_link sprintf("<< %s", I18n.t('header.list')), href: root_path
    end
  end

  context 'When a user creates a task' do
    it 'Success to create a task' do
      visit new_task_path
  
      fill_in 'task[title]', with: 'Automation Test Task'
      fill_in 'task[description]', with: 'Please create the automation test for this task.'
      select 'Middle', from: I18n.t('header.priority')
      select 'Open', from: I18n.t('header.status')
      click_on 'commit'
  
      expect(page).to have_content I18n.t('flash.create.success')
    end

    xit 'Fail to create a task because of validatio error' do
    end
  end

  context 'When a user edits a task' do
    it 'Success to edit a task' do
      visit edit_task_path(@task1.id)
  
      fill_in 'task[title]', with: 'Change the title'
      fill_in 'task[description]', with: 'I changed the title.'
      select 'High', from: I18n.t('header.priority')
      select 'InProgress', from: I18n.t('header.status')
      click_on 'commit'
      
      expect(page).to have_content I18n.t('flash.update.success')
    end

    xit 'Fail to create a task because of validatio error' do
    end
  end

  context 'When a user deletes a task' do
    it 'Success to delete a task from list page' do
      visit tasks_path

      click_on I18n.t('operation.remove'), match: :first
      expect(page).to have_content I18n.t('flash.remove.success')
    end

    it 'Success to delete a task from detail page' do
      visit task_path(@task1.id)

      click_on I18n.t('operation.remove')
      expect(page).to have_content I18n.t('flash.remove.success')
    end
  end
end