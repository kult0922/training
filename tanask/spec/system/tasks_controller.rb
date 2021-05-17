require 'rails_helper'

RSpec.describe 'TasksControllers', type: :system do
  let!(:task1) { FactoryBot.create(:task_template, name: "test_name1", description: 'test_description1') }
  let!(:task2) { FactoryBot.create(:task_template, name: "test_name2", description: 'test_description2') }

  describe 'index' do
    before do
      visit '/tasks'
    end

    it 'show Task List' do
      expect(page).to have_content('Task list')
    end

    # before do :task end
    context "If the user has a task" do
      let!(:task1) { FactoryBot.create(:task_template, name: "test_name1", description: 'test_description1') }
      it 'show test_task1' do
        expect(page).to have_content('test_name1')
      end
    end

    it 'can go to new task page' do
      click_on 'Make New Task'
      expect(page).to have_content('Make new Task')
    end
  end

  describe 'show' do

    before do :task end
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
      fill_in 'Name', with: 'newtask1'
      fill_in 'Description', with: 'newdescription1'
      click_on 'SUBMIT'
      expect(page).to have_content('newtask1')
    end
  end

  describe 'edit' do
    before do
      visit '/tasks/1/edit'
    end
    it 'can see detail page' do
      expect(page).to have_content('Edit Task')
    end
    it 'cat edit task' do
      fill_in 'Name', with: 'edited_task1'
      fill_in 'Description', with: 'edited_description1'
      click_on 'SUBMIT'
      expect(page).to have_content('edited_task1')
    end
  end

  describe 'delete' do
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
