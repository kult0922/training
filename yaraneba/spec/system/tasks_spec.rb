# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe '#task' do
    it 'create task' do
      visit new_task_path
      fill_in 'Title', with: 'title'
      fill_in 'Detail', with: 'detail'
      fill_in 'Status', with: '1'
      fill_in 'Priority', with: '1'

      click_button 'Create Task'
      expect(page).to have_content 'title'
    end

    it 'update task' do
      task = create(:task)
      visit edit_task_path(task)

      fill_in 'Title', with: 'sample'
      expect(page).to have_field 'Detail', with: 'detail'
      click_button 'Update Task'

      expect(page).to have_content 'sample'
    end
  end
end
