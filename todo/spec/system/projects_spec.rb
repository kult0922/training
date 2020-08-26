# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :system do
  let!(:project) { create(:project) }
  let!(:user) { create(:user) }
  let!(:user_project) { create(:user_project, user_id: user.id, project_id: project.id) }

  describe '#index' do
    before {login(user)}
    context 'when index page visit' do
      it 'factory bot project is visible' do
        visit projects_path

        expect(page).to have_content 'PJ_Factory'
        expect(page).to have_content 'タスク一覧'
        expect(page).to have_content '修正'
        expect(page).to have_content '削除'
      end
    end
  end

  describe '#new' do
    before do
      login(user)
      visit new_project_path
    end

    context 'create new project' do
      it 'project was created' do
        fill_in 'project_project_name', with: 'input_test'
        fill_in 'project_description', with: 'test'
        select 'In Progress', from: 'project_status'
        fill_in 'project_started_at', with: Time.zone.parse('07/12/2020')
        fill_in 'project_finished_at', with: Time.zone.parse('07/12/2020')

        click_on '登録する'
        expect(page).to have_content 'プロジェクトが作成されました。'
        expect(Project.find_by(project_name: 'input_test'))
      end
    end

    context 'error when project create' do
      it 'error new project' do
        fill_in 'project_description', with: 'test'
        select 'In Progress', from: 'project_status'

        click_on '登録する'
        expect(page).to have_content 'PJ名を入力してください'
        expect(page).to have_content '開始日を入力してください'
        expect(page).to have_content '終了日を入力してください'
      end
    end
  end

  describe '#show' do
    context 'when task is click' do
      it 'move to the project detail page' do
        visit project_path(project.id)
        expect(page).to have_content 'PJ_Factory'
        expect(page).to have_content 'factory_test'
        expect(page).to have_content 'In Progress'
        expect(page).to have_content '2020-08-01'
        expect(page).to have_content '2020-08-05'
      end
    end
  end

  describe '#edit' do
    before do
      login(user)
      visit edit_project_path(project)
    end

    context 'when project edit' do
      it 'project was updated' do
        fill_in 'project_project_name', with: 'edit_test'
        fill_in 'project_description', with: 'test2'
        select 'To Do', from: 'project_status'
        fill_in 'project_started_at', with: Time.zone.parse('10/11/2020')
        fill_in 'project_finished_at', with: Time.zone.parse('10/12/2020')

        click_on '更新する'
        expect(page).to have_content 'プロジェクトが更新されました。'
        expect(Project.find_by(project_name: 'edit_test'))
      end
    end

    context 'error when project edit' do
      it 'error edit project' do
        fill_in 'project_project_name', with: ''
        fill_in 'project_description', with: 'test'
        select 'In Progress', from: 'project_status'
        fill_in 'project_started_at', with: ''
        fill_in 'project_finished_at', with: ''

        click_on '更新する'
        expect(page).to have_content 'PJ名を入力してください'
        expect(page).to have_content '開始日を入力してください'
        expect(page).to have_content '終了日を入力してください'
      end
    end
  end

  describe '#delete' do
    before {login(user)}
    context 'when project delete' do
      it 'project was deleted' do
        visit projects_path
        click_link '削除', href: project_path(project.id)
        expect(page.driver.browser.switch_to.alert.text).to eq '削除してもよろしいでしょうか?'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'プロジェクトが削除されました。'
      end
    end
  end
end
