require 'rails_helper'
require 'bcrypt'

RSpec.describe 'Task', js: true, type: :system do
  describe 'task' do
    let!(:user) { create(:user) }
    let!(:task1) { create(:task, user: user) }
    let!(:task2) { create(:task, user: user) }

    it 'task list' do
      visit_with_basic_auth root_path
      expect(page).to have_content(task1.title)
      expect(page).to have_content(task2.title)
    end

    it 'new task' do
      visit_with_basic_auth new_task_path
      fill_in 'Title', with: 'title'
      fill_in 'Description', with: 'description'
      click_button 'Submit'

      expect(page).to have_content('Task was successfully created.')
      visit root_path
      expect(page).to have_content('title')
    end

    it 'edit task' do
      visit_with_basic_auth task_path(task1)
      expect(page).to have_field 'Title', with: task1.title
      expect(page).to have_field 'Description', with: task1.description

      fill_in 'Title', with: 'tittleeeeeee'
      fill_in 'Description', with: 'descriptionnnnnn'
      click_button 'Submit'

      expect(page).to have_content('Task was successfully updated.')
      expect(page).to have_field 'Title', with: 'tittleeeeeee'
      expect(page).to have_field 'Description', with: 'descriptionnnnnn'
      visit root_path
      expect(page).to have_content 'tittleeeeeee'
    end

    it 'delete task' do
      visit_with_basic_auth task_path(task2)
      expect(page).to have_field 'Title', with: task2.title

      page.accept_confirm "Are you sure to delete ?" do
        click_button('Delete')
      end

      expect(page).to have_content('Task was successfully destroyed.')
      visit root_path
      expect(page).not_to have_content(task2.title)
    end
  end
end
