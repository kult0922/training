require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { FactoryBot.create(:user) }

  context 'not login' do
    scenario 'can not access to tasks page' do
      visit tasks_path
      expect(current_path).to eq(new_sessions_path)
      expect(page).to have_content I18n.t('sessions.flash.not_authrize')
    end

    scenario 'navbar content' do
      visit tasks_path
      expect(find('.navbar')).not_to have_content "#{user.name}#{I18n.t('navbar.Mr')}"
      expect(find('.navbar')).to have_content I18n.t('navbar.login')
    end
  end

  describe 'login' do
    scenario 'success' do
      login(user)
      expect(current_path).to eq(root_path)
      expect(page).to have_content I18n.t('sessions.flash.create')
    end

    scenario 'failed' do
      user.email = 'wrong_email@test.com'
      login(user)
      expect(current_path).to eq(new_sessions_path)
      expect(page).to have_content I18n.t('sessions.flash.create_fail')
    end

    scenario 'navbar content' do
      login(user)
      expect(find('.navbar')).to have_content "#{user.name}#{I18n.t('navbar.Mr')}"
      expect(find('.navbar')).to have_content I18n.t('navbar.logout')
    end
  end

  scenario 'logout' do
    login(user)
    click_link I18n.t('navbar.logout')
    expect(current_path).to eq(new_sessions_path)
    expect(page).to have_content I18n.t('sessions.flash.destroy')
  end

  scenario 'restrict_own_task' do
    task = FactoryBot.create(:task)
    login(user)

    visit edit_task_path(task)
    expect(current_path).to eq(root_path)
    expect(page).to have_content I18n.t('tasks.flash.restrict_own_task')
  end
end
