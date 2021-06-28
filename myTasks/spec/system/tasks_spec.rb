require 'rails_helper'

RSpec.describe Task, type: :system do
  let!(:task1) { create(:task1) }
  let!(:task2) { create(:task2) }
  let!(:task3) { create(:task3) }

  describe 'Task CRUD' do
    describe 'create task' do
      context 'valid form input' do
        it 'create success' do
          visit new_task_path
          fill_in 'task[name]', with: 'new task'
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button I18n.t('helpers.submit.create')
          expect(current_path).to eq root_path
          expect(page).to have_content I18n.t('flash.create')
        end
      end

      context 'invalid form input' do
        it 'create failed' do
          visit new_task_path
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button I18n.t('helpers.submit.create')
          expect(current_path).to eq tasks_path
          expect(page).to have_content I18n.t('flash.create_failure')
        end
      end
    end

    describe 'read task' do
      context 'read all tasks' do
        it 'read all tasks success' do
          get tasks_path
          expect(response.status).to eq 200
          expect(response.body).to have_content 'task1'
          expect(response.body).to have_content 'task2'
          expect(response.body).to have_content 'task3'
        end
      end

      context 'read task detail' do
        it 'read task detail success' do
          get task_path(task1)
          expect(response.status).to eq 200
          expect(response.body).to have_content 'task1'
        end
      end
    end

    describe 'update task' do
      context 'valid form input' do
        it 'edit success' do
          visit edit_task_path(task1)
          fill_in 'task[name]', with: 'my task'
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button I18n.t('helpers.submit.update')
          expect(current_path).to eq root_path
          expect(page).to have_content I18n.t('flash.update')
        end
      end

      context 'invalid form input' do
        it 'edit failed' do
          visit edit_task_path(task1)
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button I18n.t('helpers.submit.update')
          expect(current_path).to eq task_path(task1)
          expect(page).to have_content I18n.t('flash.update_failure')
        end
      end
    end

    describe 'delete task' do
      context 'click delete button' do
        it 'delete success' do
          visit task_path(task1)
          click_link I18n.t('tasks.show.destroy')
          expect(current_path).to eq root_path
          expect(page).to have_content I18n.t('flash.destroy')
        end
      end
    end
  end
end
