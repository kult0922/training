require 'rails_helper'

RSpec.describe Task, type: :system do
  describe 'Task CRUD' do
    describe 'error handle' do
      context 'some error check' do
        it 'standard error' do
          allow_any_instance_of(TasksController).to receive(:index).and_raise(StandardError, 'error')
          visit root_path
          expect(page).to have_content 'ページが表示できません'
        end

        it 'Record Not Found' do
          visit 'tasks/0'
          expect(page).to have_content 'お探しのページは見つかりません'
        end

        it 'Routing Error' do
          visit 'hoge'
          expect(page).to have_content 'お探しのページは見つかりません'
        end
      end
    end

    describe 'create task' do
      context 'valid form input' do
        it 'create success' do
          visit new_task_path
          fill_in 'task[name]', with: 'new task'
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '002014/01/01'
          fill_in 'task[priority]', with: 1
          click_button 'create'
          expect(current_path).to eq root_path
          expect(page).to have_content '作成しました！'
        end
      end

      context 'invalid form input' do
        it 'create failed (name is missing)' do
          visit new_task_path
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '002021-06-24'
          fill_in 'task[priority]', with: 1
          click_button 'create'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '名前を入力してください'
        end

        it 'create failed (priority is invalid)' do
          visit new_task_path
          fill_in 'task[name]', with: 'new task'
          fill_in 'task[description]', with: 'this is new task'
          fill_in 'task[end_date]', with: '002021-06-24'
          fill_in 'task[priority]', with: 'abc'
          click_button 'create'
          expect(current_path).to eq tasks_path
          expect(page).to have_content '優先度は数値で入力してください'
        end
      end
    end

    describe 'read task' do
      let!(:task1) { create(:task, name: 'task1') }
      let!(:task2) { create(:task, name: 'task2') }
      let!(:task3) { create(:task, name: 'task3') }
      let!(:task4) { create(:task, name: 'task4') }
      let!(:task5) { create(:task, name: 'task5') }
      let!(:task6) { create(:task, name: 'task6') }
      let!(:task7) { create(:task, name: 'task7') }
      let!(:task8) { create(:task, name: 'task8') }
      let!(:task9) { create(:task, name: 'task9') }
      let!(:task10) { create(:task, name: 'task10') }
      let!(:task11) { create(:task, name: 'task11') }
      let!(:task12) { create(:task, name: 'task12') }

      context 'read all tasks' do
        it 'read all tasks success' do
          visit root_path
          tasks = page.all('.task-container')
          # 作成日の降順に表示されていることを確認
          expect(tasks[0].text).to have_content 'task12'
          expect(tasks[1].text).to have_content 'task11'
          expect(tasks[2].text).to have_content 'task10'
          expect(tasks[3].text).to have_content 'task9'
          expect(tasks[4].text).to have_content 'task8'
          expect(tasks[5].text).to have_content 'task7'
          expect(tasks[6].text).to have_content 'task6'
          expect(tasks[7].text).to have_content 'task5'
          expect(tasks[8].text).to have_content 'task4'
          # 次のページに移動
          click_link 'Next'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'task3'
          expect(tasks[1].text).to have_content 'task2'
          expect(tasks[2].text).to have_content 'task1'
        end
      end

      context 'read task detail' do
        it 'read task detail success' do
          visit task_path(task1)
          expect(page.text).to have_content 'task1'
        end
      end
    end

    describe 'update task' do
      let(:task) { create(:task) }
      context 'valid form input' do
        it 'edit success' do
          visit edit_task_path(task)
          fill_in 'task[name]', with: 'my task'
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '002021-06-24'
          fill_in 'task[priority]', with: 1
          click_button 'update'
          expect(current_path).to eq root_path
          expect(page).to have_content '更新しました！'
        end
      end

      context 'invalid form input' do
        it 'edit failed (name is missing)' do
          visit edit_task_path(task)
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '002021-06-24'
          fill_in 'task[priority]', with: 1
          click_button 'update'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '名前を入力してください'
        end

        it 'edit failed (priority is invalid)' do
          visit edit_task_path(task)
          fill_in 'task[name]', with: ''
          fill_in 'task[description]', with: 'this is my task'
          fill_in 'task[end_date]', with: '002021-06-24'
          fill_in 'task[priority]', with: 'abc'
          click_button 'update'
          expect(current_path).to eq task_path(task)
          expect(page).to have_content '優先度は数値で入力してください'
        end
      end
    end

    describe 'delete task' do
      let(:task) { create(:task) }
      context 'click delete button' do
        it 'delete success' do
          visit task_path(task)
          click_link 'delete'
          expect(current_path).to eq root_path
          expect(page).to have_content '削除しました！'
        end
      end
    end

    describe 'search task' do
      # ステータスの異なるprivate_taskの作成
      # 優先度: 1, 締切日: 10日後
      let!(:private_task_todo) { create(:task, :private, name: 'private_task_todo', status: 'todo') }
      let!(:private_task_in_progress) { create(:task, :private, name: 'private_task_in_progress', status: 'in_progress') }
      let!(:private_task_done) { create(:task, :private, name: 'private_task_done', status: 'done') }

      # ステータスの異なるwork_taskの作成
      # 優先度: 5, 締切日: 5日後
      let!(:work_task_todo) { create(:task, :work, name: 'work_task_todo', status: 'todo') }
      let!(:work_task_in_progress) { create(:task, :work, name: 'work_task_in_progress', status: 'in_progress') }
      let!(:work_task_done) { create(:task, :work, name: 'work_task_done', status: 'done') }

      # ステータスの異なるemergency_taskの作成
      # 優先度: 10, 締切日: 今日
      let!(:emergency_task_todo) { create(:task, :emergency, name: 'emergency_task_todo', status: 'todo') }
      let!(:emergency_task_in_progress) { create(:task, :emergency, name: 'emergency_task_in_progress', status: 'in_progress') }
      let!(:emergency_task_done) { create(:task, :emergency, name: 'emergency_task_done', status: 'done') }

      context 'check search name function' do
        it 'search name=private_task sort_by ID ASC' do
          visit root_path
          fill_in 'name', with: 'private_task'
          select 'ID', from: 'sort'
          select '昇順', from: 'direction'
          click_button 'Search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_todo'
          expect(tasks[1].text).to have_content 'private_task_in_progress'
          expect(tasks[2].text).to have_content 'private_task_done'
        end

        it 'search name=task sort_by ID ASC' do
          visit root_path
          fill_in 'name', with: 'task'
          select 'ID', from: 'sort'
          select '昇順', from: 'direction'
          click_button 'Search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_todo'
          expect(tasks[1].text).to have_content 'private_task_in_progress'
          expect(tasks[2].text).to have_content 'private_task_done'
          expect(tasks[3].text).to have_content 'work_task_todo'
          expect(tasks[4].text).to have_content 'work_task_in_progress'
          expect(tasks[5].text).to have_content 'work_task_done'
          expect(tasks[6].text).to have_content 'emergency_task_todo'
          expect(tasks[7].text).to have_content 'emergency_task_in_progress'
          expect(tasks[8].text).to have_content 'emergency_task_done'
        end
      end

      context 'check status filter function' do
        before do
          visit root_path
          select 'ID', from: 'sort'
          select '昇順', from: 'direction'
        end

        it 'status=TODO sort_by ID ASC' do
          select 'TODO', from: 'status'
          click_button 'Search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_todo'
          expect(tasks[1].text).to have_content 'work_task_todo'
          expect(tasks[2].text).to have_content 'emergency_task_todo'
        end

        it 'status=WIP sort_by ID ASC' do
          select 'WIP', from: 'status'
          click_button 'Search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_in_progress'
          expect(tasks[1].text).to have_content 'work_task_in_progress'
          expect(tasks[2].text).to have_content 'emergency_task_in_progress'
        end

        it 'status=DONE sort_by ID ASC' do
          select 'DONE', from: 'status'
          click_button 'Search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_done'
          expect(tasks[1].text).to have_content 'work_task_done'
          expect(tasks[2].text).to have_content 'emergency_task_done'
        end
      end

      context 'check search name function and status filter function' do
        before do
          visit root_path
          select 'ID', from: 'sort'
          select '昇順', from: 'direction'
        end

        it 'name=work_task status=WIP sort_by ID ASC' do
          fill_in 'name', with: 'work_task'
          select 'WIP', from: 'status'
          click_button 'Search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'work_task_in_progress'
        end

        it 'name=task status=DONE sort_by ID ASC' do
          fill_in 'name', with: 'task'
          select 'DONE', from: 'status'
          click_button 'Search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'private_task_done'
          expect(tasks[1].text).to have_content 'work_task_done'
          expect(tasks[2].text).to have_content 'emergency_task_done'
        end
      end

      context 'check sort function' do
        it 'sort_by end_date ASC' do
          visit root_path
          select '締切', from: 'sort'
          select '昇順', from: 'direction'
          click_button 'Search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'emergency_task_todo'
          expect(tasks[1].text).to have_content 'emergency_task_in_progress'
          expect(tasks[2].text).to have_content 'emergency_task_done'
          expect(tasks[3].text).to have_content 'work_task_todo'
          expect(tasks[4].text).to have_content 'work_task_in_progress'
          expect(tasks[5].text).to have_content 'work_task_done'
          expect(tasks[6].text).to have_content 'private_task_todo'
          expect(tasks[7].text).to have_content 'private_task_in_progress'
          expect(tasks[8].text).to have_content 'private_task_done'
        end

        it 'sort_by priority DESC' do
          visit root_path
          select '優先度', from: 'sort'
          select '降順', from: 'direction'
          click_button 'Search'
          tasks = page.all('.task-container')
          expect(tasks[0].text).to have_content 'emergency_task_todo'
          expect(tasks[1].text).to have_content 'emergency_task_in_progress'
          expect(tasks[2].text).to have_content 'emergency_task_done'
          expect(tasks[3].text).to have_content 'work_task_todo'
          expect(tasks[4].text).to have_content 'work_task_in_progress'
          expect(tasks[5].text).to have_content 'work_task_done'
          expect(tasks[6].text).to have_content 'private_task_todo'
          expect(tasks[7].text).to have_content 'private_task_in_progress'
          expect(tasks[8].text).to have_content 'private_task_done'
        end
      end
    end
  end
end
