require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'ValidationRunsWhenCreatingTasks' do
    before do
      @task = build(:invalid_sample_task)
    end
    it 'is invalid when creating new task' do
      @task.valid?
      expect(@task.errors.messages.any?).to eq true
    end
  end
end
