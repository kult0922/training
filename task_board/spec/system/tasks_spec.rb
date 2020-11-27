require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:test_name) { 'test2' }
  let(:test_description) { 'test2_description' }
  let!(:user) { create(:user) }
  let!(:task) { create(:task, user_id: user.id) }
  let!(:label) { create(:label, user_id: user.id) }

  before do
    visit login_path
    fill_in 'session_email', with: user.email
    fill_in 'session_password', with: user.password
    click_button 'ログイン'
  end

  describe '#index' do
    it 'visit index page' do
      visit root_path
      expect(page).to have_content 'test_1'
    end

    describe 'sorting' do
      let!(:taskA) { create(:task, name: 'Task_end_1days', end_date: Time.current + 1.days, user_id: user.id) }
      let!(:taskB) { create(:task, name: 'Task_end_3days', end_date: Time.current + 3.days, user_id: user.id) }
      before do
        visit root_path
      end
      context 'before click sort link' do
        it 'sort table by created_at in descending order' do
          expect(page.body.index(taskA.name)).to be > page.body.index(taskB.name)
        end
      end

      context 'click sort link' do
        before { click_link '最終期限' }
        it 'sort table by end_date in ascending order' do
          sleep 1
          expect(page.body.index(taskA.name)).to be < page.body.index(taskB.name)
        end

        it 'sort table by end_date in descending order' do
          sleep 1
          click_link '最終期限'
          sleep 1
          expect(page.body.index(taskA.name)).to be > page.body.index(taskB.name)
        end
      end
    end

    describe 'search' do
      let!(:taskA) { create(:task, name: 'Task_apple', status: :todo, user_id: user.id) }
      let!(:taskB) { create(:task, name: 'Task_banana', status: :in_progress, user_id: user.id) }
      let!(:taskC) { create(:task, name: 'Task_lemon', status: :done, user_id: user.id) }
      let(:click) { click_button '検索' }

      before do
        visit root_path
      end

      context 'search by name' do
        before { fill_in 'q_name_cont', with: 'apple' }
        it 'display taskA' do
          click
          expect(page.all('table tbody tr').count).to eq 1
          expect(page).to have_content taskA.name
          expect(page).to_not have_content taskB.name
        end
      end

      context 'search by status' do
        before { select '完了', from: 'q_status_eq' }
        it 'display taskC' do
          click
          expect(page.all('table tbody tr').count).to eq 1
          expect(page).to have_content taskC.name
          expect(page).to_not have_content taskA.name
        end
      end

      context 'search by name and status' do
        before do
          fill_in 'q_name_cont', with: 'Task'
          select '進行中', from: 'q_status_eq'
        end
        it 'display taskB' do
          click
          expect(page.all('table tbody tr').count).to eq 1
          expect(page).to have_content taskB.name
          expect(page).to_not have_content taskC.name
        end
      end

      context 'search by label' do
        before do
          taskC.reload.label_ids = [label.id]
          select label.name, from: 'q_labels_name_eq'
        end

        it 'display task with label' do
          click
          expect(page.all('table tbody tr').count).to eq 1
          expect(page).to have_content taskC.name
        end
      end
    end

    describe 'pagination' do
      before do
        10.times do |n|
          create(:task, name: "task-#{n}", status: :todo, user_id: user.id)
        end
        visit root_path
      end

      context 'first page' do
        it 'show Next link in pagination' do
          expect(page).to have_link 'Next'
          expect(page).to have_link 'Last'
        end
      end

      context 'click Next page' do
        it 'show Previous link in pagination' do
          click_link 'Next'
          expect(page).to have_link 'Previous'
          expect(page).to have_link 'First'
        end
      end
    end
  end

  describe '#new' do
    before { visit new_task_path }
    context 'with valid form' do
      before do
        fill_in 'task_name', with: test_name
        fill_in 'task_description', with: test_description
      end
      it 'success to create task' do
        click_button '作成'
        expect(current_path).to eq tasks_path
        expect(page).to have_content "タスク「#{test_name}」を登録しました。"
      end
    end

    context 'with invalid form' do
      before do
        fill_in 'task_description', with: test_description
      end
      it 'fail to create task' do
        click_button '作成'
        expect(page).to have_content 'タスク名を入力してください'
      end
    end
  end

  describe '#show' do
    it 'visit show page' do
      visit task_path(task)
      expect(page).to have_content 'test_1'
    end
  end

  describe '#edit' do
    before { visit edit_task_path(task) }
    context 'with valid form' do
      before do
        fill_in 'task_name', with: test_name
      end
      it 'success to update the task' do
        click_button '更新'
        expect(current_path).to eq tasks_path
        expect(page).to have_content "タスク「#{test_name}」を更新しました。"
        expect(Task.find(task.id).name).to eq test_name
      end
    end
  end

  describe '#destroy' do
    before { visit tasks_path }
    it 'destroy task' do
      click_button '削除', match: :first
      expect(page.driver.browser.switch_to.alert.text).to eq "タスク：「#{task.name}」、本当に削除しますか？"
      expect { page.driver.browser.switch_to.alert.accept }.to change { Task.count }.by(0)
      expect(page).to have_content "タスク「#{task.name}」を削除しました。"
    end
  end
end
