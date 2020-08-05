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

  describe 'search' do
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
      todo_task = Task.status_search(:todo, task.project_id)
      expect(todo_task.count).to eq 3
      expect(todo_task[0].status).to eq 'todo'
      expect(todo_task[1].status).to eq 'todo'
      expect(todo_task[2].status).to eq 'todo'
      expect(todo_task[3]).to be_nil

      in_progress_task = Task.status_search(:in_progress, task.project_id)
      expect(in_progress_task.count).to eq 2
      expect(in_progress_task[0].status).to eq 'in_progress'
      expect(in_progress_task[1].status).to eq 'in_progress'
      expect(in_progress_task[2]).to be_nil

      done_task = Task.status_search(:done, task.project_id)
      expect(done_task.count).to eq 1
      expect(done_task[0].status).to eq 'done'
      expect(done_task[1]).to be_nil
    end

    it 'search priority' do
      low_priority_task = Task.priority_search(:low, task.project_id)
      expect(low_priority_task.count).to eq 2
      expect(low_priority_task[0].priority).to eq 'low'
      expect(low_priority_task[1].priority).to eq 'low'
      expect(low_priority_task[2]).to be_nil

      mid_priority_task = Task.priority_search(:mid, task.project_id)
      expect(mid_priority_task.count).to eq 2
      expect(mid_priority_task[0].priority).to eq 'mid'
      expect(mid_priority_task[1].priority).to eq 'mid'
      expect(mid_priority_task[2]).to be_nil

      high_priority_task = Task.priority_search(:high, task.project_id)
      expect(high_priority_task.count).to eq 2
      expect(high_priority_task[0].priority).to eq 'high'
      expect(high_priority_task[1].priority).to eq 'high'
      expect(high_priority_task[2]).to be_nil
    end

    it 'order finished_at' do
      desc_finished_at = Task.order_search(:desc, task.project_id)
      expect(desc_finished_at[4].finished_at < desc_finished_at[3].finished_at).to be true
      expect(desc_finished_at[3].finished_at < desc_finished_at[2].finished_at).to be true
      expect(desc_finished_at[2].finished_at < desc_finished_at[1].finished_at).to be true
      expect(desc_finished_at[1].finished_at < desc_finished_at[0].finished_at).to be true

      asc_finished_at = Task.order_search(:asc, task.project_id)
      expect(asc_finished_at[4].finished_at > asc_finished_at[3].finished_at).to be true
      expect(asc_finished_at[3].finished_at > asc_finished_at[2].finished_at).to be true
      expect(asc_finished_at[2].finished_at > asc_finished_at[1].finished_at).to be true
      expect(asc_finished_at[1].finished_at > asc_finished_at[0].finished_at).to be true
    end
  end
end
