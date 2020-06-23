require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:task) { build(:task, name: task_name) }
  subject { task }

  context 'name is between 2 and 24 characters' do
    let(:task_name) { 'hoge '}
    it { is_expected.to be_valid }
  end

  context 'name is less than 2 characters' do
    let(:task_name) { '1' }
    it 'raise a error' do
      is_expected.not_to be_valid
      expect(subject.errors.full_messages).to eq ['名前は2文字以上で入力してください']
    end
  end

  context 'name is more than 24 characters' do
    let(:task_name) { 'abcdefghijklmnopqrstuvwxy' }
    it 'raise a error' do
      is_expected.not_to be_valid
      expect(subject.errors.full_messages).to eq ['名前は24文字以内で入力してください']
    end
  end

  context 'user_id is null' do
    subject { build(:task, name: 'task', user: nil) }
    it 'raise a error' do
      is_expected.not_to be_valid
      expect(subject.errors.full_messages).to eq ['作成者を入力してください']
    end
  end

  context 'search function' do
    let!(:task1) { create(:task, name: 'task1', status: 0) }
    let!(:task2) { create(:task, name: 'task2', status: 1) }
    let!(:task3) { create(:task, name: 'task3', status: 2) }
    let!(:task4) { create(:task, name: 'task4', status: 1) }
    let!(:taskA) { create(:task, name: 'タスクA', status: 0) }
    let!(:taskB) { create(:task, name: 'タスクB', status: 2) }
  
    it 'could search tasks by name & status' do
      test_cases = [
        { name: 'task', status: 1 },
        { name: 'タスク', status: nil },
        { name: '', status: 2 },
        { name: '', status: nil }
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
