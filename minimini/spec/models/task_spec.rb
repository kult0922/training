require 'rails_helper'

RSpec.describe Task, type: :model do
  before(:each) do
    @task = FactoryBot.build(:task)
  end

  it 'is valid with name, description, due_date' do
    expect(@task).to be_valid
  end

  it 'is invalid without a name' do
    @task.name = nil
    expect(@task).to be_invalid
    expect(@task.errors[:name]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a description' do
    @task.description = nil
    expect(@task).to be_invalid
    expect(@task.errors[:description]).to include(I18n.t('errors.messages.blank'))
  end

  it 'is invalid without a due_date' do
    @task.due_date = nil
    expect(@task).to be_invalid
    expect(@task.errors[:due_date]).to include(I18n.t('errors.messages.blank'))
  end
end
