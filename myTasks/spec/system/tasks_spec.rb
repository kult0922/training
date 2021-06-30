require 'rails_helper'

RSpec.describe Task, type: :system do

  describe 'Task CRUD' do
    describe 'create task' do
      context 'valid form input' do
        it 'create success' do
          visit new_task_path
          fill_in 'task[name]', with: 'new task'
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button '作成'
          expect(current_path).to eq root_path
          expect(page).to have_content '作成しました！'
        end
      end

      context 'invalid form input' do
        it 'create failed (name is missing)' do
          visit new_task_path
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button '作成'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '名前を入力してください'
        end

        it 'create failed (end_date is invalid)' do
          visit new_task_path
          fill_in 'task[name]', with: 'new task'
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: 'abc'
          fill_in 'task[priority]', with: 1
          click_button '作成'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '締切は不正な値です'
        end

        it 'create failed (priority is invalid)' do
          visit new_task_path
          fill_in 'task[name]', with: 'new task'
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 'abc'
          click_button '作成'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '優先度は数値で入力してください'
        end
      end
    end

    describe 'read task' do
      let!(:task1) { create(:task1) }
      let!(:task2) { create(:task2) }
      let!(:task3) { create(:task3) }
      context 'read all tasks' do
        it 'read all tasks success' do
          visit root_path
          tasks = page.all('.task-container')
          # 作成日の降順に表示されていることを確認
          expect(tasks[0].text).to have_content task3.name
          expect(tasks[1].text).to have_content task2.name
          expect(tasks[2].text).to have_content task1.name
        end
      end

      context 'read task detail' do
        it 'read task detail success' do
          visit task_path(task1)
          expect(page.text).to have_content task1.name
        end
      end
    end

    describe 'update task' do
      let(:task1) { create(:task1) }
      context 'valid form input' do
        it 'edit success' do
          visit edit_task_path(task1)
          fill_in 'task[name]', with: 'my task'
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button '更新'
          expect(current_path).to eq root_path
          expect(page).to have_content '更新しました！'
        end
      end

      context 'invalid form input' do
        it 'edit failed (name is missing)' do
          visit edit_task_path(task1)
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 1
          click_button '更新'
          expect(current_path).to eq task_path(task1)
          expect(page).to have_content '名前を入力してください'
        end

        it 'edit failed (end_date is invalid)' do
          visit edit_task_path(task1)
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: 'abc'
          fill_in 'task[priority]', with: 1
          click_button '更新'
          expect(current_path).to eq task_path(task1)
          expect(page).to have_content '締切は不正な値です'
        end

        it 'edit failed (priority is invalid)' do
          visit edit_task_path(task1)
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '2021-06-24'
          fill_in 'task[priority]', with: 'abc'
          click_button '更新'
          expect(current_path).to eq task_path(task1)
          expect(page).to have_content '優先度は数値で入力してください'
        end
      end
    end

    describe 'delete task' do
      let(:task1) { create(:task1) }
      context 'click delete button' do
        it 'delete success' do
          visit task_path(task1)
          click_link '削除'
          expect(current_path).to eq root_path
          expect(page).to have_content '削除しました！'
        end
      end
    end

    describe 'sort task' do
      let!(:task1) { create(:task1) }
      let!(:task2) { create(:task2) }
      let!(:task3) { create(:task3) }
      context 'sort tasks by end_date' do
        it 'read all tasks success' do
          visit root_path
          click_link 'ソート：締め切り'
          tasks = page.all('.task-container')
          # 締切日の昇順に表示されていることを確認
          expect(tasks[0].text).to have_content task1.name
          expect(tasks[1].text).to have_content task2.name
          expect(tasks[2].text).to have_content task3.name

          click_link 'ソート：締め切り'
          tasks = page.all('.task-container')
          # 締切日の降順に表示されていることを確認
          expect(tasks[0].text).to have_content task3.name
          expect(tasks[1].text).to have_content task2.name
          expect(tasks[2].text).to have_content task1.name
        end
      end
    end
  end
end
