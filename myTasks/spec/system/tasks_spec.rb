require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:task) { create(:task) }

  describe 'Task CRUD' do
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
        end
      end
    end

    describe 'update task' do
      context 'valid form input' do
        it 'edit success' do
          visit edit_task_path(task)
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
          visit edit_task_path(task)
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button 'update'
          expect(current_path).to eq task_path(task)
        end
      end
    end

    describe 'delete task' do
      context 'click delete button' do
        it 'delete success' do
          visit task_path(task)
          click_link 'delete'
          expect(current_path).to eq root_path
          expect(page).to have_content 'Delete Task!'
        end
      end
    end
  end

end
