require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:not_proceed) { FactoryBot.create(:not_proceed) }
  let!(:in_progress) { FactoryBot.create(:in_progress) }
  let!(:done) { FactoryBot.create(:done) }
  let!(:user1) { FactoryBot.create(:user) }
  let!(:task1) { create(:task, name: 'task1', status: not_proceed, user: user1) }
  let!(:task2) { create(:task, name: 'task2', status: in_progress, user: user1) }
  let!(:task3) { create(:task, name: 'task3', status: done, user: user1) }
  let!(:task4) { create(:task, name: 'task4', status: in_progress, user: user1) }
  let!(:taskA) { create(:task, name: 'タスクA', status: not_proceed, user: user1) }
  let!(:taskB) { create(:task, name: 'タスクB', status: done, user: user1) }

  context 'name is not blank' do
    it 'should be success' do
      t = Task.new(name: 'hoge', description: '', status: in_progress, user: user1)
      expect(t).to be_valid
    end
  end

  context 'name is blank' do
    it 'should be failure' do
      t = Task.new(name: '', description: '', status: in_progress, user: user1)
      t.valid?
      expect(t.errors.full_messages).to eq ['名前を入力してください']
    end
  end

  context 'statu_id is null' do
    it 'should be failure' do
      t = Task.new(name: 'hoge', description: '', user: user1)
      t.valid?
      expect(t.errors.full_messages).to eq ['ステータスを入力してください']
    end
  end

  context 'user_id is null' do
    it 'should be failure' do
      t = Task.new(name: 'hoge', description: '', status: in_progress)
      t.valid?
      expect(t.errors.full_messages).to eq ['作成者を入力してください']
    end
  end

  context 'search function' do
    it 'search tasks by name & status' do
      cases = [
        { name: 'task', status: in_progress.id, user: user1 },
        { name: 'タスク', status: nil, user: user1 },
        { name: '', status: done.id, user: user1 },
        { name: '', status: nil, user: user1 }
      ]

      outputs = [
        [task2, task4],
        [taskA, taskB],
        [task3, taskB],
        [task1, task2, task3, task4, taskA, taskB]
      ]

      cases.each_with_index do |c, i|
        expect(Task.search(c)).to eq outputs[i]
      end
    end
  end
end
