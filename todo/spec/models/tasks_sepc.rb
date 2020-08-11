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

  describe 'task where' do
    context 'when task search' do
      before do
        create(:task, :order_by_finished_at, assignee_id: user.id, reporter_id: user.id, task_name: 'mywork1', status: :todo, priority: :low)
        create(:task, :order_by_finished_at, assignee_id: user.id, reporter_id: user.id, task_name: 'mywork2', status: :in_progress, priority: :mid)
        create(:task, :order_by_finished_at, assignee_id: user.id, reporter_id: user.id, task_name: 'your work1', status: :done, priority: :high)
        create(:task, :order_by_finished_at, assignee_id: user.id, reporter_id: user.id, task_name: 'your work2', status: :in_progress, priority: :mid)
        create(:task, :order_by_finished_at, assignee_id: user.id, reporter_id: user.id, task_name: 'your work3', status: :todo, priority: :low)
      end

      it 'search task_name' do
        search_word1 = 'my'
        search_word2 = 'your'

        get_name1 = Task.name_search(search_word1, task.project_id)

        expect(get_name1.count).to eq 2
        expect(get_name1[0].task_name).to include(search_word1)
        expect(get_name1[1].task_name).to include(search_word1)
        expect(get_name1[2]).to be_nil

        get_name2 = Task.name_search(search_word2, task.project_id)

        expect(get_name2.count).to eq 3
        expect(get_name2[0].task_name).to include(search_word2)
        expect(get_name2[1].task_name).to include(search_word2)
        expect(get_name2[2].task_name).to include(search_word2)
        expect(get_name1[3]).to be_nil
      end

      it 'search status' do
        todo_task = Task.sta_search(:todo, task.project_id)
        expect(todo_task.count).to eq 3
        expect(todo_task[0].status).to eq 'todo'
        expect(todo_task[1].status).to eq 'todo'
        expect(todo_task[2].status).to eq 'todo'
        expect(todo_task[3]).to be_nil

        in_progress_task = Task.sta_search(:in_progress, task.project_id)
        expect(in_progress_task.count).to eq 2
        expect(in_progress_task[0].status).to eq 'in_progress'
        expect(in_progress_task[1].status).to eq 'in_progress'
        expect(in_progress_task[2]).to be_nil

        done_task = Task.sta_search(:done, task.project_id)
        expect(done_task.count).to eq 1
        expect(done_task[0].status).to eq 'done'
        expect(done_task[1]).to be_nil
      end

      it 'search priority' do
        low_priority_task = Task.pri_search(:low, task.project_id)
        expect(low_priority_task.count).to eq 2
        expect(low_priority_task[0].priority).to eq 'low'
        expect(low_priority_task[1].priority).to eq 'low'
        expect(low_priority_task[2]).to be_nil

        mid_priority_task = Task.pri_search(:mid, task.project_id)
        expect(mid_priority_task.count).to eq 2
        expect(mid_priority_task[0].priority).to eq 'mid'
        expect(mid_priority_task[1].priority).to eq 'mid'
        expect(mid_priority_task[2]).to be_nil

        high_priority_task = Task.pri_search(:high, task.project_id)
        expect(high_priority_task.count).to eq 2
        expect(high_priority_task[0].priority).to eq 'high'
        expect(high_priority_task[1].priority).to eq 'high'
        expect(high_priority_task[2]).to be_nil
      end

      it 'order finished_at' do
        desc_finished_at = Task.order_by(:desc, task.project_id)
        expect(desc_finished_at[4].finished_at < desc_finished_at[3].finished_at).to be true
        expect(desc_finished_at[3].finished_at < desc_finished_at[2].finished_at).to be true
        expect(desc_finished_at[2].finished_at < desc_finished_at[1].finished_at).to be true
        expect(desc_finished_at[1].finished_at < desc_finished_at[0].finished_at).to be true

        asc_finished_at = Task.order_by(:asc, task.project_id)
        expect(asc_finished_at[4].finished_at > asc_finished_at[3].finished_at).to be true
        expect(asc_finished_at[3].finished_at > asc_finished_at[2].finished_at).to be true
        expect(asc_finished_at[2].finished_at > asc_finished_at[1].finished_at).to be true
        expect(asc_finished_at[1].finished_at > asc_finished_at[0].finished_at).to be true
      end
    end
  end
end
