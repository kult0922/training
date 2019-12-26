require 'rails_helper'

RSpec.describe Task, :type => :model do
  context 'When user creates task' do
    it 'ensures title presence' do
      task = Task.create(description: 'no title')
      expect(task).to be_invalid
    end

    it 'ensures title length is less than 50' do
      task = Task.create(title: 'a' * 51, description: 'simple description')
      expect(task).to be_invalid
    end
  end

  context 'When user edits task' do
    it 'ensures title presence' do
      task = Task.create(title: 'sample title', description: 'sample description')
      expect(task).to be_valid
      task.update(title: '')
      expect(task).to be_invalid
    end

    it 'ensures title length is less than 50' do
      task = Task.create(title: 'short title', description: 'short description')
      expect(task).to be_valid
      task.update(title: 'a' * 51)
      expect(task).to be_invalid
    end
  end
end
