# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:task) { create(:task, assignee_id: user.id, reporter_id: user.id) }

  describe 'validation valid' do
    it 'task valid' do
      expect(task).to be_valid
    end
  end

  describe 'validation invalid(task_name)' do
    before do
      task.task_name = ''
    end

    it 'task name invalid(blank)' do
      expect(task).to be_invalid
      expect(task.errors[:task_name][0]).to eq I18n.t('tasks.errors.input')
    end
  end

  describe 'validation invalid(started_at)' do
    before do
      task.started_at = ''
    end

    it 'task started_at invalid(blank)' do
      expect(task).to be_invalid
      expect(task.errors[:started_at][0]).to eq I18n.t('tasks.errors.input')
    end
  end

  describe 'validation invalid(finished_at)' do
    before do
      task.finished_at = ''
    end

    it 'task finished_at invalid(blank)' do
      expect(task).to be_invalid
      expect(task.errors[:finished_at][0]).to eq I18n.t('tasks.errors.input')
    end
  end

  describe 'validation invalid(assignee_id)' do
    before do
      task.assignee_id = ''
    end

    it 'task assignee_id invalid(blank)' do
      expect(task).to be_invalid
      expect(task.errors[:assignee][0]).to eq I18n.t('tasks.errors.input')
    end
  end

  describe 'validation invalid(reporter_id)' do
    before do
      task.reporter_id = ''
    end

    it 'task reporter_id invalid(blank)' do
      expect(task).to be_invalid
      expect(task.errors[:reporter][0]).to eq I18n.t('tasks.errors.input')
    end
  end
end
