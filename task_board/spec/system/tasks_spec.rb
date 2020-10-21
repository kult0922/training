require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:test_name) { 'test2' }
  let(:test_description) { 'test2_description' }
  let!(:task) { create(:task) }

  describe '#index' do
    it 'visit index page' do
      visit root_path
      expect(page).to have_content 'test_1'
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
        expect(page).to have_content "Name can't be blank"
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
