# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:user) { create(:user) }
  let(:task) { create(:task, user: user) }

  describe '#index' do
    context 'visit task index page' do
      before do
        login_as(user)
        visit tasks_path(task)
      end

      it 'the users record exists' do
        expect(page).to have_content 'タスク一覧'
        expect(page).to have_content '新規作成'
        expect(page).to have_content 'タスク名'
        expect(page).to have_content 'タスク説明文'
        expect(page).to have_content '詳細'
        expect(page).to have_content '編集'

        expect(page).to have_content task.title
        expect(page).to have_content task.description

        click_on '削除'
        expect(page).to have_content 'タスクを削除しました'
        expect(Task.count).to eq 0
      end
    end

    context 'when click due_date' do
      let!(:task_dute_date_late) {
        create(
          :task,
          due_date: task.due_date.tomorrow,
          user: user,
        )
      }

      before do
        login_as(user)
        visit root_path
      end

      it 'once' do
        click_link '終了期限'

        expect(all('tbody tr').first).to have_content task.title
      end

      it 'twice' do
        click_link '終了期限'
        click_link '終了期限'

        expect(all('tbody tr').first).to have_content task_dute_date_late.title
      end
    end
  end

  describe '#new' do
    before do
      login_as(user)
      visit new_task_path(task)
      fill_in 'Title', with: 'create_title'
      fill_in 'Description', with: 'create_description'
    end

    it 'visit task new page' do
      expect(page).to have_content 'タスク作成'

      click_on '登録'

      expect(page).to have_content 'タスクを作成しました'

      expect(page).to have_content 'create_title'
      expect(page).to have_content 'create_description'

      expect(Task.find_by(title: 'create_title'))
      expect(Task.find_by(description: 'create_description'))
    end
  end

  describe '#show' do
    before do
      login_as(user)
      visit task_path(task)
    end

    it 'visit task show page' do
      expect(page).to have_content 'タスク詳細'

      expect(page).to have_content task.title
      expect(page).to have_content task.description
    end
  end

  describe '#edit' do
    before do
      login_as(user)
      visit edit_task_path(task)

      fill_in 'Title', with: 'edit_title'
      fill_in 'Description', with: 'edit_description'
    end

    it 'visit task edit page' do
      expect(page).to have_content 'タスク編集'

      click_on '登録'

      expect(page).to have_content 'edit_title'
      expect(page).to have_content 'edit_description'

      expect(Task.find_by(title: 'edit_title'))
      expect(Task.find_by(description: 'edit_description'))
    end
  end

  describe '#error_page' do
    before do
      login_as(user)
    end

    context 'when access a path that does not exist' do
      it '404 error page is displayed' do
        visit '/tasks/404test'

        expect(page).to have_content "The page you were looking for doesn't exist."
      end
    end

    context 'when transition to 500 error page' do
      it '500 error page is displayed' do
        # Generate an exception when transitioning to the index
        allow_any_instance_of(TasksController).to receive(:index).and_throw(Exception)
        visit tasks_path

        expect(page).to have_content "We're sorry, but something went wrong."
      end
    end
  end
end
