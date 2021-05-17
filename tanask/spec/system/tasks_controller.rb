require 'rails_helper'

RSpec.describe 'TasksControllers', type: :system do
  describe 'index' do
    let!(:task1) { FactoryBot.create(:task1) }
    before do
      visit '/tasks'
      # Task.create(name: 'test_task1', description: 'test_description1')
    end

    it 'can see Task List' do
      expect(page).to have_content('Task list')
    end

    it 'can see test_task1' do
      expect(page).to have_content('test_task1')
    end

    it 'can go to new task page' do
      click_on 'Make New Task'
      expect(page).to have_content('Make new Task')
    end
  end

  describe 'show' do
    let!(:task1) { FactoryBot.create(:task1) }

    it 'can see detail page' do
      visit '/tasks/1'
      expect(page).to have_content('The detail of Task')
    end
  end

  describe 'new' do
    before do
      visit '/tasks/new'
    end
    
    it 'can see new task page' do
      expect(page).to have_content('Make new Task')
    end
    it 'can add new task' do
      visit '/tasks/new'
      fill_in 'Name', with: 'newtask1'
      fill_in 'Description', with: 'newdescription1'
      click_on 'SUBMIT'
      expect(page).to have_content('newtask1')
    end
  end

  describe 'edit' do
    before do
      Task.create(name: 'test_task1', description: 'test_description1')
    end
    it 'can see detail page' do
      visit '/tasks/1/edit'
      expect(page).to have_content('Edit Task')
    end
    it 'cat edit task' do
      visit '/tasks/1/edit'
      fill_in 'Name', with: 'edited_task1'
      fill_in 'Description', with: 'edited_description1'
      click_on 'SUBMIT'
      expect(page).to have_content('edited_task1')
    end
  end

  describe 'delete' do
    before do
      Task.create(name: 'test_task1', description: 'test_description1')
      Task.create(name: 'test_task2', description: 'test_description2')
    end
    it 'can delete' do
      visit '/tasks/2'
      click_on 'Delete this task'
      expect {
        expect(page.accept_confirm)
        expect(page).to_not have_content('test_task2')
      }
    end
  end
end
