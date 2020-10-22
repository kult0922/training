require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:valid_task) { build(:task) }
  it 'is valid with valid attributes' do
    expect(valid_task).to be_valid
  end

  context 'invalid cases' do
    let(:invalid_task_no_title) { build(:task, name: nil) }
    let(:invaild_task_long_title) { build(:task, name: 'a' * 51) }
    it 'is not valid without a title' do
      expect(invalid_task_no_title).to_not be_valid
    end

    it 'is not valid with title over 50 length' do
      expect(invaild_task_long_title).to_not be_valid
    end
  end
end
