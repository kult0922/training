# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  let!(:added_task) { create(:task) }

  describe '#index' do
    context 'トップページにアクセスした場合' do
      example '表示できる' do
        visit root_path
        expect(page).to have_content added_task.name
      end
    end
  end

  describe '#show(task_id)' do
    context '詳細ページにアクセスした場合' do
      example 'タスク詳細を表示できる' do
        visit task_path(added_task.id)
        expect(page).to have_content added_task.name
      end
    end
  end

  describe '#new' do
    before { visit new_task_path }
    context 'with valid form' do
      before do
        fill_in 'name', with: added_task.name
        fill_in 'details', with: added_task.details
      end
      example 'タスクを正常に登録できる' do

      end
    end

    describe '#edit' do
      before { visit new_task_path }
      context 'with valid form' do
        before do
          fill_in 'name', with: added_task.name
          fill_in 'details', with: added_task.details
        end
        example 'タスクを正常に登録できる' do

        end
      end
    end
  end
end
