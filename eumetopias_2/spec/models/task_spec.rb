require 'rails_helper'

RSpec.describe Task, type: :model do
  it 'is invalid without title and description' do
    new_task = Task.new()
    new_task.valid?
    expect(new_task.errors.messages[:title]).to include('を入力してください')
    expect(new_task.errors.messages[:description]).to include('を入力してください')
  end
end
