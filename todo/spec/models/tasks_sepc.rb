# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }
  let(:task) { create(:task, assignee_id: user.id, reporter_id: user.id) }
  subject { task }

  context 'validation valid' do
    it 'task valid' do
      is_expected.to be_valid
    end
  end

  context 'validation invalid(task_name)' do
    before do
      task.task_name = ''
    end

    it 'task name is invalid(blank)' do
      is_expected.to be_invalid
      expect(task.errors.full_messages[0]).to eq 'タスク名を入力してください'
    end
  end

  context 'validation invalid(started_at)' do
    before do
      task.started_at = ''
    end

    it 'task started_at is invalid(blank)' do
      is_expected.to be_invalid
      expect(task.errors.full_messages[0]).to eq '開始日を入力してください'
    end
  end

  context 'validation invalid(finished_at)' do
    before do
      task.finished_at = ''
    end

    it 'task finished_at is invalid(blank)' do
      is_expected.to be_invalid
      expect(task.errors.full_messages[0]).to eq '終了日を入力してください'
    end
  end

  context 'validation invalid(assignee_id)' do
    before do
      task.assignee_id = ''
    end

    it 'task assignee_id is invalid(blank)' do
      is_expected.to be_invalid
      expect(task.errors.full_messages[0]).to eq 'Assigneeを入力してください'
    end
  end

  context 'validation invalid(reporter_id)' do
    before do
      task.reporter_id = ''
    end

    it 'task reporter_id is invalid(blank)' do
      is_expected.to be_invalid
      expect(task.errors.full_messages[0]).to eq 'Reporterを入力してください'
    end
  end
end
