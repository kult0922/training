# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:task) { create(:task) }

  describe '#index' do
    before do
      visit tasks_path(task)
    end

    it 'visit task index page' do
      expect(page).to have_content 'Task List'
      expect(page).to have_content 'Create New Task'
      expect(page).to have_content 'Title'
      expect(page).to have_content 'Description'
      expect(page).to have_content 'show'
      expect(page).to have_content 'edit'

      expect(page).to have_content task.title
      expect(page).to have_content task.description

      click_on 'destroy'
      expect(page).to have_content 'Deleted task'
      expect(Task.count).to eq 0
    end
  end

  describe '#new' do
    before do
      visit new_task_path(task)
      fill_in 'Title', with: 'create_title'
      fill_in 'Description', with: 'create_description'
    end

    it 'visit task new page' do
      expect(page).to have_content 'New Task'

      click_on 'Create Task'

      expect(page).to have_content 'Added task'

      expect(page).to have_content 'create_title'
      expect(page).to have_content 'create_description'

      expect(Task.find_by(title: 'create_title'))
      expect(Task.find_by(description: 'create_description'))
    end
  end

  describe '#show' do
    before do
      visit task_path(task)
    end

    it 'visit task show page' do
      expect(page).to have_content 'Task Detail'

      expect(page).to have_content task.title
      expect(page).to have_content task.description
    end
  end

  describe '#edit' do
    before do
      visit edit_task_path(task)

      fill_in 'Title', with: 'edit_title'
      fill_in 'Description', with: 'edit_description'
    end

    it 'visit task edit page' do
      click_on 'Update Task'

      expect(page).to have_content 'Edited task'

      expect(page).to have_content 'edit_title'
      expect(page).to have_content 'edit_description'

      expect(Task.find_by(title: 'edit_title'))
      expect(Task.find_by(description: 'edit_description'))
    end
  end
end
