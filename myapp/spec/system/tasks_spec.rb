# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:task) { create(:task) }

  describe '#index' do
    before do
      visit tasks_path(task)
    end

    it 'visit task index page' do
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

  describe '#new' do
    before do
      visit new_task_path(task)
      fill_in 'Title', with: 'create_title'
      fill_in 'Description', with: 'create_description'
    end

    it 'visit task new page' do
      expect(page).to have_content 'タスク作成'

      click_on '登録する'

      expect(page).to have_content 'タスクを作成しました'

      expect(page).to have_content 'create_title'
      expect(page).to have_content 'create_description'

      expect(Task.find_by(title: 'create_title'))
      expect(Task.find_by(description: 'create_description'))
    end
  end

  describe '#show' do
    before do
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
      visit edit_task_path(task)

      fill_in 'Title', with: 'edit_title'
      fill_in 'Description', with: 'edit_description'
    end

    it 'visit task edit page' do
      expect(page).to have_content 'タスク編集'

      click_on '更新する'

      expect(page).to have_content 'edit_title'
      expect(page).to have_content 'edit_description'

      expect(Task.find_by(title: 'edit_title'))
      expect(Task.find_by(description: 'edit_description'))
    end
  end
end
