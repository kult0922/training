require 'rails_helper'

RSpec.describe 'TasksControllers', type: :system do
  describe 'index' do
    before do
      Task.create(name: 'test_task1', description: 'test_description1')
    end

    it 'can see Task List' do
      visit '/tasks'
      expect(page).to have_content('Task list')
    end

    it 'can see test_task1' do
      visit '/tasks'
      expect(page).to have_content('test_task1')
    end

    it 'can go to new task page' do
      visit '/tasks'
      click_on 'Make New Task'
      expect(page).to have_content('Make new Task')
    end
  end

  describe 'new' do
    before do
      Task.create(name: 'test_task1', description: 'test_description1')
    end

    it 'can see new task page' do
      visit '/tasks/new'
      expect(page).to have_content('Make new Task')
    end
  end
end

