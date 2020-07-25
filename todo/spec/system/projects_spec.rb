# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :system do
  let!(:project) { create(:project) }

  describe '#index' do
    it 'visit project index page' do
      visit projects_path

      expect(page).to have_content 'PJ_Factory'
      expect(page).to have_content 'factory_test'
      expect(page).to have_content 'タスク一覧'
      expect(page).to have_content '修正'
      expect(page).to have_content '削除'
    end
  end

  describe '#new' do
    before  do
      visit new_project_path

      fill_in 'project_project_name', with: 'input_test'
      fill_in 'project_description', with: 'test'
      select 'In Progress', from: 'project_status'
      fill_in 'project_started_at', with: Time.new(2020, 01, 02, 12)
      fill_in 'project_finished_at', with: Time.new(2020, 01, 02, 12)
    end
    
    it 'Create new project' do
      click_on 'Create Project'
      expect(page).to have_content 'プロジェクトが追加されました。'
      expect(Project.find_by(project_name: 'input_test'))
    end
  end
  
  describe '#show' do
    it 'check project detail page' do
      visit project_path(project.id)
      expect(page).to have_content project.project_name
      expect(page).to have_content project.description
      expect(page).to have_content project.status
      expect(page).to have_content project.started_at
      expect(page).to have_content project.finished_at
    end
  end

  describe '#edit' do
    before do
      visit edit_project_path(project)

      fill_in 'project_project_name', with: 'edit_test'
      fill_in 'project_description', with: 'test2'
      select 'To Do', from: 'project_status'
      fill_in 'project_started_at', with: Date.today
      fill_in 'project_finished_at', with: Date.today
    end

    it 'edit project' do
      click_on 'Update Project'
      expect(page).to have_content 'プロジェクトが更新されました。'
      expect(Project.find_by(project_name: 'edit_test'))
    end
  end

  describe '#delete' do
    before do
      visit projects_path
    end
    it 'delete project' do
      click_link '削除', href: project_path(project.id)
      expect(page.driver.browser.switch_to.alert.text).to eq "削除してもよろしいでしょうか?"
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'プロジェクトが削除されました。'
    end
  end
end
