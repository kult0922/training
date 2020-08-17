# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:task) { create(:task, assignee_id: user.id, reporter_id: user.id) }
  subject { task }

  context 'validation valid' do
    it { is_expected.to be_valid }
  end

  context 'validation invalid(task_name)' do
    it 'task name is invalid(blank)' do
      task.task_name = ''
      is_expected.to be_invalid
      expect(task.errors.full_messages[0]).to eq 'タスク名を入力してください'
    end
  end

  context 'validation invalid(started_at)' do
    it 'task started_at is invalid(blank)' do
      task.started_at = ''
      is_expected.to be_invalid
      expect(task.errors.full_messages[0]).to eq '開始日を入力してください'
    end
  end

  context 'validation invalid(finished_at)' do
    it 'task finished_at is invalid(blank)' do
      task.finished_at = ''
      is_expected.to be_invalid
      expect(task.errors.full_messages[0]).to eq '終了日を入力してください'
    end
  end

  context 'validation invalid(assignee_id)' do
    it 'task assignee_id is invalid(blank)' do
      task.assignee_id = ''
      is_expected.to be_invalid
      expect(task.errors.full_messages[0]).to eq 'Assigneeを入力してください'
    end
  end

  context 'validation invalid(reporter_id)' do
    it 'task reporter_id is invalid(blank)' do
      task.reporter_id = ''
      is_expected.to be_invalid
      expect(task.errors.full_messages[0]).to eq 'Reporterを入力してください'
    end
  end
end
