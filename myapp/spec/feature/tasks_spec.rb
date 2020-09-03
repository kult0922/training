# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :feature do
  let!(:task) { create(:task) }
  let!(:task_other) { create(:task) }

  describe '#index' do
    before do
      task_other.update(
        created_at: task.created_at.tomorrow,
      )
      visit root_path
    end

    context 'when there are multiple tasks' do
      it 'sort by created_at desc' do
        expect(all('tbody tr').count > 1).to be_truthy
        expect(all('tbody tr').first.text).to have_content task_other.title
      end
    end
  end

  describe '#search form' do
    before do
      task_other.update(
        status: 'wip', # because, default value is 'yet'.
      )
      visit tasks_path(task)
    end

    it 'there are two records' do
      expect(all('tbody tr').count > 1).to be_truthy

      expect(page).to have_content task.title
      expect(page).to have_content task_other.title
    end

    context 'when searching by title' do
      it 'only the task.title' do
        fill_in 'Title_cont', with: task.title
        click_on '検索'

        expect(page).to have_content task.title
        expect(page).not_to have_content task_other.title
      end
    end

    context 'when searching while status is wip' do
      it 'only the task.title' do
        select '未着手', from: 'Status_eq'
        click_on '検索'

        expect(page).to have_content task.title
        expect(page).not_to have_content task_other.title
      end
    end
  end
end
