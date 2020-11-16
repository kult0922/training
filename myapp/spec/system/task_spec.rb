require 'rails_helper'
require 'bcrypt'

RSpec.describe 'Task', js: true, type: :system do
  describe 'task' do
    let!(:user) { create(:user) }
    let!(:task1) { create(:task, user: user) }
    let!(:task2) { create(:task, user: user) }

    it 'task list' do
      visit_with_basic_auth root_path
      expect(page.text).to match(/#{task2.title}.*\n*.*#{task1.title}/)
    end

    it 'search task' do
      visit_with_basic_auth root_path
      fill_in 'q_title_cont', with: task1.title
      click_button I18n.t('search')
      expect(page).to have_content task1.title
      expect(page).not_to have_content task2.title

      choose 'q_status_eq_2'
      click_button I18n.t('search')
      expect(page).not_to have_content task1.title
      expect(page).not_to have_content task2.title
    end

    it 'new task' do
      visit_with_basic_auth new_task_path
      click_button I18n.t('submit')

      task = Task.new(user: user)
      task.valid?

      expect(task.errors.full_messages.length).to be 2
      expect(page).to have_content task.errors.full_messages.join("\n")

      fill_in I18n.t('title'), with: 't' * 101
      click_button I18n.t('submit')

      task.title = 't' * 101
      task.valid?
      expect(task.errors.full_messages.length).to be 1
      expect(page).to have_content task.errors.full_messages.join("\n")

      fill_in I18n.t('title'), with: 'title'
      fill_in I18n.t('description'), with: 'description'
      click_button I18n.t('submit')

      expect(page).to have_content I18n.t('controllers.tasks.notice_task_created')
      visit root_path
      expect(page).to have_content('title')
    end

    it 'edit task' do
      visit_with_basic_auth task_path(task1)
      expect(page).to have_field I18n.t('title'), with: task1.title
      expect(page).to have_field I18n.t('description'), with: task1.description

      fill_in I18n.t('title'), with: 'tittleeeeeee'
      fill_in I18n.t('description'), with: 'descriptionnnnnn'
      click_button I18n.t('submit')

      expect(page).to have_content I18n.t('controllers.tasks.notice_task_updated')
      expect(page).to have_field I18n.t('title'), with: 'tittleeeeeee'
      expect(page).to have_field I18n.t('description'), with: 'descriptionnnnnn'
      visit root_path
      expect(page).to have_content 'tittleeeeeee'
    end

    it 'delete task' do
      visit_with_basic_auth task_path(task2)
      expect(page).to have_field I18n.t('title'), with: task2.title

      page.accept_confirm I18n.t('delete_confirm') do
        click_button(I18n.t('delete'))
      end

      expect(page).to have_content(I18n.t('controllers.tasks.notice_task_deleted'))
      visit root_path
      expect(page).not_to have_content(task2.title)
    end
  end

  describe 'pagination' do
    context 'only one page' do
      let!(:task) { create(:task) }

      it 'paginator not rendered' do
        visit_with_basic_auth root_path
        expect(page).not_to have_selector '.pagination'
      end

    end

    context 'more than one page' do
      let!(:tasks) { create_list(:task, 26) }

      it 'first page' do
        visit_with_basic_auth root_path
        expect(page).to have_selector '.pagination'
        expect(page).not_to have_link '1', href: root_path
        expect(page).to have_link '2', href: root_path(page: 2)
        expect(page).not_to have_link '3', href: root_path(page: 3)
      end

      it 'second page' do
        visit_with_basic_auth root_path(page: 2)
        expect(page).to have_selector '.pagination'
        expect(page).to have_link '1', href: root_path
        expect(page).not_to have_link '2', href: root_path(page: 2)
        expect(page).not_to have_link '3', href: root_path(page: 3)
      end

    end
  end
end
