require 'rails_helper'

RSpec.describe Task, type: :model do
  let(:user) { create(:user) }

  it 'without user' do
    task = Task.new
    expect(task).not_to be_valid
  end

  it 'empty title' do
    task = Task.new(user: user)
    expect(task).not_to be_valid
  end

  it 'title exceed max length' do
    task = Task.new(title: 't' * 101)
    expect(task).not_to be_valid
  end

  it 'description exeed max length' do
    task = Task.new(title: 't', description: 'd' * 2001)
    expect(task).not_to be_valid
  end

  it 'valid' do
    task = Task.new(user: user, title: 't' * 100, description: 'd' * 2000)
    expect(task).to be_valid
  end

end
