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
      expect(task.errors.full_messages[1]).to eq '開始日の日付形式が正しくありません'
    end
  end

  context 'validation invalid(finished_at)' do
    it 'task finished_at is invalid(blank)' do
      task.finished_at = ''
      is_expected.to be_invalid
      expect(task.errors.full_messages[0]).to eq '終了日を入力してください'
      expect(task.errors.full_messages[1]).to eq '終了日の日付形式が正しくありません'
      expect(task.errors.full_messages[2]).to eq '終了日は開始日付より後の日付にしてください'
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
      let!(:task1) { create(:task, :order_by_finished_at, assignee_id: user.id, reporter_id: user.id, task_name: 'mywork1', status: :todo, priority: :low) }
      let!(:task2) { create(:task, :order_by_finished_at, assignee_id: user.id, reporter_id: user.id, task_name: 'mywork2', status: :in_progress, priority: :mid) }
      let!(:task3) { create(:task, :order_by_finished_at, assignee_id: user.id, reporter_id: user.id, task_name: 'your work1', status: :done, priority: :high) }
      let!(:task4) { create(:task, :order_by_finished_at, assignee_id: user.id, reporter_id: user.id, task_name: 'your work2', status: :in_progress, priority: :mid) }
      let!(:task5) { create(:task, :order_by_finished_at, assignee_id: user.id, reporter_id: user.id, task_name: 'your work3', status: :todo, priority: :low) }

      describe '#name_search' do
        context 'when task name is my to search' do
          it 'result 2 rows' do
            get_name1 = Task.name_search('my')

            expect(get_name1.count).to eq 2
            expect(get_name1[0].task_name).to include('my')
            expect(get_name1[1].task_name).to include('my')
            expect(get_name1[2]).to be_nil
          end
        end

        context 'when task name is your search' do
          it 'result 3 rows' do
            get_name2 = Task.name_search('your')

            expect(get_name2.count).to eq 3
            expect(get_name2[0].task_name).to include('your')
            expect(get_name2[1].task_name).to include('your')
            expect(get_name2[2].task_name).to include('your')
            expect(get_name2[3]).to be_nil
          end
        end
      end

      describe '#status_search' do
        context 'when todo task search' do
          it 'result 2 rows' do
            todo_task = Task.status_search(:todo)
            expect(todo_task.count).to eq 2
            expect(todo_task[0].status).to eq 'todo'
            expect(todo_task[1].status).to eq 'todo'
            expect(todo_task[2]).to be_nil
          end
        end
        context 'when in_progress task search' do
          it 'result 2 rows' do
            in_progress_task = Task.status_search(:in_progress)
            expect(in_progress_task.count).to eq 2
            expect(in_progress_task[0].status).to eq 'in_progress'
            expect(in_progress_task[1].status).to eq 'in_progress'
            expect(in_progress_task[2]).to be_nil
          end
        end
        context 'when task status done' do
          it 'result 1 row' do
            done_task = Task.status_search(:done)
            expect(done_task.count).to eq 1
            expect(done_task[0].status).to eq 'done'
            expect(done_task[1]).to be_nil
          end
        end
      end

      describe '#priority_search' do
        context 'when task low priority search' do
          it 'result 2 rows' do
            low_priority_task = Task.priority_search(:low)
            expect(low_priority_task.count).to eq 2
            expect(low_priority_task[0].priority).to eq 'low'
            expect(low_priority_task[1].priority).to eq 'low'
            expect(low_priority_task[2]).to be_nil
          end
        end

        context 'when task mid priorirty search' do
          it 'result 2 rows' do
            mid_priority_task = Task.priority_search(:mid)
            expect(mid_priority_task.count).to eq 2
            expect(mid_priority_task[0].priority).to eq 'mid'
            expect(mid_priority_task[1].priority).to eq 'mid'
            expect(mid_priority_task[2]).to be_nil
          end
        end

        context 'when task high priority search' do
          it 'result 1 row' do
            high_priority_task = Task.priority_search(:high)
            expect(high_priority_task.count).to eq 1
            expect(high_priority_task[0].priority).to eq 'high'
            expect(high_priority_task[1]).to be_nil
          end
        end
      end

      describe '#finished_at_order' do
        context 'when task order by desc' do
          it 'first task finished_at is biggest' do
            desc_finished_at = Task.order_by_at(:desc)
            expect(desc_finished_at[4].finished_at < desc_finished_at[3].finished_at).to be true
            expect(desc_finished_at[3].finished_at < desc_finished_at[2].finished_at).to be true
            expect(desc_finished_at[2].finished_at < desc_finished_at[1].finished_at).to be true
            expect(desc_finished_at[1].finished_at < desc_finished_at[0].finished_at).to be true
          end
        end

        context 'when task order by asc' do
          it 'forth task finishied_at is biggest' do
            asc_finished_at = Task.order_by_at(:asc)
            expect(asc_finished_at[4].finished_at > asc_finished_at[3].finished_at).to be true
            expect(asc_finished_at[3].finished_at > asc_finished_at[2].finished_at).to be true
            expect(asc_finished_at[2].finished_at > asc_finished_at[1].finished_at).to be true
            expect(asc_finished_at[1].finished_at > asc_finished_at[0].finished_at).to be true
          end
        end
      end
    end
  end
end
