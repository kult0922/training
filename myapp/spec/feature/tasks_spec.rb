# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :feature do
  let(:user) { create(:user) }
  let!(:task) { create(:task, user: user) }
  let!(:task_other) { create(:task, user: user) }

  describe '#index' do
    let(:user_other) { create(:user) }
    let!(:user_other_task) { create(:task, user: user) }

    before do
      task_other.update(
        created_at: task.created_at.tomorrow,
      )
      login_as(user)
      visit user_tasks_path(task)
    end

    context 'when there are multiple tasks' do
      it 'sort by created_at desc' do
        expect(all('tbody tr').count > 1).to be_truthy
        expect(all('tbody tr').first).to have_content task_other.title
        expect(all('tbody tr').first).not_to have_content user_other_task.title
      end
    end
  end

  describe '#search form' do
    before do
      task_other.update(
        status: 'doing', # because, default value is 'open'.
      )
      login_as(user)
      visit user_tasks_path(task)
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

    context 'when searching while status is doing' do
      it 'only the task.title' do
        select '未着手', from: 'Status_eq'
        click_on '検索'

        expect(page).to have_content task.title
        expect(page).not_to have_content task_other.title
      end
    end
  end
end
