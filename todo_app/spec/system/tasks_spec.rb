require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task1) { create(:task, title: 'タイトル1') }
  let!(:task2) { create(:past_task, title: 'タイトル2') }

  describe "タスク一覧" do
    it 'タスク一覧が表示されている (/)' do
      visit root_path

      expect(page).to have_content task1.title
      expect(page).to have_content task1.description
    end

    it 'タスク一覧が表示されている (/tasks)' do
      visit tasks_path

      expect(page).to have_content task1.title
      expect(page).to have_content task1.description
    end

    it 'タスク一覧の順序が作成日降順' do
      visit tasks_path

      expect(all('tbody tr')[1].text).to match task1.title
      expect(all('tbody tr')[2].text).to match task2.title
    end
  end

  describe "タスク詳細" do
    it 'タスク詳細が表示される' do
      visit task_path(task1)

      expect(page).to have_content task1.title
      expect(page).to have_content task1.description
    end
  end

  describe "タスク編集" do
    it 'タスクを変更できる' do
      visit edit_task_path(task1)

      fill_in 'task_title', with: 'hoge'
      fill_in 'task_description', with: 'fuga'
      click_button I18n.t(:'button.edit')
      expect(page).to have_content 'hoge'
      expect(page).to have_content 'fuga'
    end

    context '異常値入力テスト' do
      it 'title Max値入力時' do
        visit edit_task_path(task1)

        fill_in 'task_title', with: Faker::Alphanumeric.alpha(number: 256)
        click_button I18n.t(:'button.edit')
        expect(page).to have_content 'Edited is failed'
      end

      it 'description Max値入力時' do
        visit edit_task_path(task1)

        fill_in 'task_description', with: Faker::Alphanumeric.alpha(number: 5001)
        click_button I18n.t(:'button.edit')
        expect(page).to have_content 'Edited is failed'
      end

      it '未入力の状態' do
        visit edit_task_path(task1)

        fill_in 'task_title', with: ''
        fill_in 'task_description', with: ''
        click_button I18n.t(:'button.edit')
        expect(page).to have_content 'Edited is failed'
      end
    end
  end

  describe "タスク削除" do
    it 'タスクを削除できる' do
      visit tasks_path

      all('tbody tr td')[3].click_link 'Delete'
      expect(page).to_not have_content task1.title
      expect(page).to have_content task2.title
    end
  end
end
