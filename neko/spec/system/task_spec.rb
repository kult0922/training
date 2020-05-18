require 'rails_helper'

describe 'task', type: :system do
  let!(:tasks) { create_list(:task, 5) }

  describe '#index' do
    context 'accress root' do
      before { visit tasks_path }

      it 'should be success to access the task list' do
        expect(page).to have_content 'タスク一覧'
        expect(page).to have_content '名前'
        expect(page).to have_content '説明'
        expect(page).to have_content '作成日'
      end

      it 'tasks should be arranged in descending date order' do
        order = tasks.map { |h| I18n.l(h[:created_at]) }.sort { |a, b| a <=> b }
        expect(page.all('.task-created_at').map(&:text)).to eq order
      end
    end
  end

  describe '#new (GET /tasks/new)' do
    before { visit new_task_path }

    context 'name is more than one letter' do
      it 'should be success' do
        fill_in '名前', with: 'hoge'
        fill_in '説明', with: 'fuga'

        click_on '登録する'
        expect(page).to have_content 'タスクを作成しました'
      end
    end

    context 'name is blank' do
      it 'should be failure' do
        fill_in '名前', with: ''
        fill_in '説明', with: 'piyo'

        click_on '登録する'
        expect(page).to have_content 'タスクの作成に失敗しました'
      end
    end
  end

  describe '#edit (GET /tasks/:id/edit)' do
    before { visit edit_task_path(tasks[0].id) }
    context 'name is more than one letter' do
      it 'should be success' do
        fill_in '名前', with: 'hogehoge'
        fill_in '説明', with: 'fugaguga'

        click_on '更新する'
        expect(page).to have_content 'タスクを更新しました'
      end
    end

    context 'name is blank' do
      it 'should be failure' do
        fill_in '名前', with: ''
        fill_in '説明', with: 'piyopiyo'

        click_on '更新する'
        expect(page).to have_content 'タスクの更新に失敗しました'
      end
    end
  end

  describe '#show (GET /tasks/:id)' do
    context 'access the detail page' do
      it 'should be success' do
        visit task_path(tasks[0].id)

        expect(page).to have_content 'タスク詳細'
        expect(page).to have_content tasks[0].name
        expect(page).to have_content tasks[0].description
      end
    end
  end

  describe '#delete (DELETE /tasks/:id)', js: true do
    context 'push delete button from detail page' do
      it 'should be success to delete the task' do
        visit task_path(tasks[0].id)

        # confirm dialog
        page.dismiss_confirm do
          click_on '削除'
          expect(page.driver.browser.switch_to.alert.text).to eq 'タスクを削除しますか？'
        end

        page.accept_confirm do
          click_on '削除'
        end

        expect(page).to have_content 'タスクを削除しました'
      end
    end
  end
end
