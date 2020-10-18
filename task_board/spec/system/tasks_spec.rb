require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:test_name) { 'test2' }
  let(:test_description) { 'test2_description' }
  let!(:task) { create(:task) }

  describe '#index' do
    it 'visit index page' do
      visit root_path
      expect(page).to have_content 'test1'
    end
  end

  describe '#new' do
    let(:submit) { '作成' }
    before { visit new_task_path }
    describe 'with valid form' do
      before do
        fill_in 'task_name', with: test_name
        fill_in 'task_description', with: test_description
      end
      it 'success to create task' do
        click_button submit
        expect(current_path).to eq tasks_path
        expect(page).to have_content "タスク「#{test_name}」を登録しました。"
      end
    end

    describe 'with invalid form' do
      before do
        fill_in 'task_description', with: test_description
      end
      it 'fail to create task' do
        click_button submit
        expect(page).to have_content "Name can't be blank"
      end
    end
  end

  describe '#show' do
    it 'visit show page' do
      visit task_path(task)
      expect(page).to have_content 'test1'
    end
  end

  describe '#edit' do
    let(:submit) { '更新' }
    before { visit edit_task_path(task) }
    describe 'with valid form' do
      before do
        fill_in 'task_name', with: test_name
      end
      it 'success to update the task' do
        click_button submit
        expect(current_path).to eq tasks_path
        expect(page).to have_content "タスク「#{test_name}」を更新しました。"
        expect(Task.find(task.id).name).to eq test_name
      end
    end
  end

  describe '#destroy' do
    let(:delete) { '削除' }
    before { visit tasks_path }
    it 'destroy task' do
      click_button delete, match: :first
      expect {
        expect(page.driver.browser.switch_to.alert.text).to eq "タスク：「#{task.name}」、本当に削除しますか？"
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content "タスク「#{task.name}」を削除しました。"
      }.to change { Task.count }.by(-1)
    end
  end
end
