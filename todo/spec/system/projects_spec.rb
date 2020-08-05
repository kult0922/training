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
      fill_in 'project_started_at', with: Time.zone.parse('07/12/2020')
      fill_in 'project_finished_at', with: Time.zone.parse('07/12/2020')
    end
    it 'Create new project' do
      click_on '登録する'
      expect(page).to have_content 'プロジェクトが作成されました。'
      expect(Project.find_by(project_name: 'input_test'))
    end
  end

  describe '#show' do
    it 'check project detail page' do
      visit project_path(project.id)
      expect(page).to have_content 'PJ_Factory'
      expect(page).to have_content 'factory_test'
      expect(page).to have_content 'In Progress'
      expect(page).to have_content '2020-08-01'
      expect(page).to have_content '2020-08-05'
    end
  end

  describe '#edit' do
    before do
      visit edit_project_path(project)

      fill_in 'project_project_name', with: 'edit_test'
      fill_in 'project_description', with: 'test2'
      select 'To Do', from: 'project_status'
      fill_in 'project_started_at', with: Time.zone.parse('10/12/2020')
      fill_in 'project_finished_at', with: Time.zone.parse('15/12/2020')
    end

    it 'edit project' do
      click_on '更新する'
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
      expect(page.driver.browser.switch_to.alert.text).to eq '削除してもよろしいでしょうか?'
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'プロジェクトが削除されました。'
    end
  end

  describe '#new error' do
    before  do
      visit new_project_path

      fill_in 'project_description', with: 'test'
      select 'In Progress', from: 'project_status'
    end
    it 'error new project' do
      click_on '登録する'
      expect(page).to have_content 'PJ名を入力してください'
      expect(page).to have_content '開始日を入力してください'
      expect(page).to have_content '終了日を入力してください'
    end
  end

  describe '#edit error' do
    before  do
      visit edit_project_path(project)

      fill_in 'project_project_name', with: ''
      fill_in 'project_description', with: 'test'
      select 'In Progress', from: 'project_status'
      fill_in 'project_started_at', with: ''
      fill_in 'project_finished_at', with: ''
    end
    it 'error edit project' do
      click_on '更新する'
      expect(page).to have_content 'PJ名を入力してください'
      expect(page).to have_content '開始日を入力してください'
      expect(page).to have_content '終了日を入力してください'
    end
  end
end
