require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe "基本操作を確認" do
    let!(:task) { create(:task) }

    it 'タスク一覧が表示されているか' do
      visit tasks_path

      expect(page).to have_content task.title
      expect(page).to have_content task.description
    end

    it 'タスク詳細が表示されるか' do
      visit task_path(task)

      expect(page).to have_content task.title
      expect(page).to have_content task.description
    end

    it 'タスクを変更できるか' do
      visit edit_task_path(task)

      fill_in 'task_title', with: 'hoge'
      fill_in 'task_description', with: 'fuga'
      click_button I18n.t(:'button.edit')
      expect(page).to have_content 'hoge'
      expect(page).to have_content 'fuga'
    end

    it 'タスクが削除できるか' do
      visit tasks_path

      click_link 'Delete'
      expect(page).to have_content 'Task deleted is complete'
      expect(page).to have_content 'Task is not registered'
    end
  end

  describe "タスク一覧の並び順の確認" do
    let!(:task1) { create(:task, title: 'タイトル1') }
    let!(:task2) { create(:past_task, title: 'タイトル2') }

    it 'タスク一覧の順序が作成日順か' do
      visit tasks_path

      expect(all('tbody tr')[1].text).to match task1.title
      expect(all('tbody tr')[2].text).to match task2.title
    end
  end
end
