require 'rails_helper'

RSpec.describe Task, type: :system do
  describe 'Task CRUD' do
    before(:each) do
      @task1 = create(:task1)
      @task2 = create(:task2)
      @task3 = create(:task3)
    end

    describe 'create task' do
      context 'valid form input' do
        it 'create success' do
          visit new_task_path
          fill_in 'task[name]', with: 'new task'
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button 'create'
          expect(current_path).to eq root_path
          expect(page).to have_content 'Create Task!'
        end
      end

      context 'invalid form input' do
        it 'create failed' do
          visit new_task_path
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button 'create'
          expect(current_path).to eq tasks_path
          expect(page).to have_content 'Could not create the task.'
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
          get task_path(@task1)
          expect(response.status).to eq 200
          expect(response.body).to have_content 'task1'
        end
      end
    end

    describe 'update task' do
      context 'valid form input' do
        it 'edit success' do
          visit edit_task_path(@task1)
          fill_in 'task[name]', with: 'my task'
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button 'update'
          expect(current_path).to eq root_path
          expect(page).to have_content 'Update Task!'
        end
      end

      context 'invalid form input' do
        it 'edit failed' do
          visit edit_task_path(@task1)
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button 'update'
          expect(current_path).to eq task_path(@task1)
          expect(page).to have_content 'Could not edit the task.'
        end
      end
    end

    describe 'delete task' do
      context 'click delete button' do
        it 'delete success' do
          visit task_path(@task1)
          click_link 'delete'
          expect(current_path).to eq root_path
          expect(page).to have_content 'Delete Task!'
        end
      end
    end
  end
end
