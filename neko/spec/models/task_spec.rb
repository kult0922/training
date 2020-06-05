require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:user1) { create(:user) }

  context 'name is not blank' do
    it 'should be success' do
      task = Task.new(name: 'hoge', description: '', status: 1, user: user1)
      expect(task).to be_valid
    end
  end

  context 'name is blank' do
    it 'should be failure' do
      task = Task.new(name: '', description: '', user: user1)
      expect(task.valid?).to eq false
      expect(task.errors.full_messages).to eq ['名前を入力してください']
    end
  end

  context 'user_id is null' do
    it 'should be failure' do
      task = Task.new(name: 'hoge', description: '')
      expect(task.valid?).to eq false
      expect(task.errors.full_messages).to eq ['作成者を入力してください']
    end
  end

  context 'search function' do
    let!(:task1) { create(:task, name: 'task1', status: 0, user: user1) }
    let!(:task2) { create(:task, name: 'task2', status: 1, user: user1) }
    let!(:task3) { create(:task, name: 'task3', status: 2, user: user1) }
    let!(:task4) { create(:task, name: 'task4', status: 1, user: user1) }
    let!(:taskA) { create(:task, name: 'タスクA', status: 0, user: user1) }
    let!(:taskB) { create(:task, name: 'タスクB', status: 2, user: user1) }

    it 'search tasks by name & status' do
      test_cases = [
        { name: 'task', status: 1, user: user1 },
        { name: 'タスク', status: nil, user: user1 },
        { name: '', status: 2, user: user1 },
        { name: '', status: nil, user: user1 }
      ]

      outputs = [
        [task2, task4],
        [taskA, taskB],
        [task3, taskB],
        [task1, task2, task3, task4, taskA, taskB]
      ]

      test_cases.each_with_index do |test_case, i|
        expect(Task.search(test_case)).to eq outputs[i]
      end
    end
  end
end
