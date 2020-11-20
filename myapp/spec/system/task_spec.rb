require 'rails_helper'

RSpec.describe 'Task', js: true, type: :system do
  describe 'vist task' do

    context 'on index' do
      let!(:tasks) { create_list(:task, 2) }

      it 'should login' do
        visit root_path
        expect(current_path).to eq login_path
      end

      it 'has two tasks' do
        visit_with_login root_path, username: tasks[0].user.name
        expect(page.text).to match(/#{tasks[1].title}.*\n*.*#{tasks[0].title}/)
      end

      context 'search tasks' do
        let!(:labels) { create_pair(:label, tasks: [ tasks[0] ]) }

        it 'by title' do
          visit_with_login root_path, username: tasks[0].user.name
          fill_in 'q_title_cont', with: tasks[0].title
          click_button I18n.t('search')
          expect(page).to have_content tasks[0].title
          expect(page).not_to have_content tasks[1].title
        end

        it 'by current user' do
          visit_with_login root_path, username: tasks[1].user.name
          choose "q_user_id_eq_#{tasks[1].user.id}"
          click_button I18n.t('search')
          expect(page).to have_content tasks[1].title
          expect(page).not_to have_content tasks[0].title
        end

        it 'by status' do
          visit_with_login root_path, username: tasks[0].user.name
          choose 'q_status_eq_2'
          click_button I18n.t('search')
          expect(page).not_to have_content tasks[0].title
          expect(page).not_to have_content tasks[1].title
        end

        it 'by label' do
          visit_with_login root_path, username: tasks[0].user.name
          choose "q_labels_id_eq_#{labels[0].id}"
          click_button I18n.t('search')
          expect(page).to have_content tasks[0].title
          expect(page).not_to have_content tasks[1].title
        end

      end # context 'search tasks'

    end # context 'on index'

    context 'on new task' do
      let!(:user) { create(:user) }
      let!(:label) { create(:label) }

      it 'should login' do
        visit new_task_path
        expect(current_path).to eq login_path
      end

      it 'submit with empty title' do
        visit_with_login new_task_path
        click_button I18n.t('submit')

        expect(page).to have_content sprintf(
          I18n.t('errors.format'),
          attribute: I18n.t('activerecord.attributes.task.title'),
          message: I18n.t('errors.messages.empty'),
        )
      end

      it 'submit with title contains 101 characters' do
        visit_with_login new_task_path
        fill_in I18n.t('title'), with: 't' * 101
        click_button I18n.t('submit')

        expect(page).to have_content sprintf(
          I18n.t('errors.format'),
          attribute: I18n.t('activerecord.attributes.task.title'),
          message: I18n.t('errors.messages.too_long', count: 100),
        )
      end

      it 'submit successfully' do
        visit_with_login new_task_path
        fill_in I18n.t('title'), with: 'title'
        fill_in I18n.t('description'), with: 'description'
        check label.name
        click_button I18n.t('submit')

        expect(page).to have_content I18n.t('controllers.tasks.notice_task_created')

        visit root_path
        expect(page).to have_content('title')
      end

    end # context 'on new task'

    context 'on edit task' do
      let!(:task) { create(:task) }
      let!(:label) { create(:label) }

      it 'submit successfully' do
        visit_with_login task_path(task), username: task.user.name
        expect(page).to have_field I18n.t('title'), with: task.title
        expect(page).to have_field I18n.t('description'), with: task.description
        expect(page).to have_unchecked_field label.name

        fill_in I18n.t('title'), with: 'tittleeeeeee'
        fill_in I18n.t('description'), with: 'descriptionnnnnn'
        check label.name
        click_button I18n.t('submit')

        expect(page).to have_content I18n.t('controllers.tasks.notice_task_updated')
        expect(page).to have_field I18n.t('title'), with: 'tittleeeeeee'
        expect(page).to have_field I18n.t('description'), with: 'descriptionnnnnn'
        expect(page).to have_checked_field label.name
        visit root_path
        expect(page).to have_content 'tittleeeeeee'
      end

    end

    context 'delete task' do 
      let!(:task) { create(:task) }

      it 'successfully' do
        visit_with_login task_path(task), username: task.user.name
        expect(page).to have_field I18n.t('title'), with: task.title

        page.accept_confirm I18n.t('delete_confirm') do
          click_button(I18n.t('delete'))
        end

        expect(page).to have_content(I18n.t('controllers.tasks.notice_task_deleted'))
        visit root_path
        expect(page).not_to have_content(task.title)
      end

    end
  end

  describe 'paginate tasks' do
    context 'only one page' do
      let!(:task) { create(:task) }

      it 'paginator not rendered' do
        visit_with_login root_path, username: task.user.name
        expect(page).not_to have_selector '.pagination'
      end

    end

    context 'more than one page' do
      let!(:user) { create(:user) }
      let!(:tasks) { create_list(:task, 26) }

      it 'first page' do
        visit_with_login root_path
        expect(page).to have_selector '.pagination'
        expect(page).not_to have_link '1', href: root_path
        expect(page).to have_link '2', href: root_path(page: 2)
        expect(page).not_to have_link '3', href: root_path(page: 3)
      end

      it 'second page' do
        visit_with_login root_path(page: 2)
        expect(page).to have_selector '.pagination'
        expect(page).to have_link '1', href: root_path
        expect(page).not_to have_link '2', href: root_path(page: 2)
        expect(page).not_to have_link '3', href: root_path(page: 3)
      end

    end
  end
end
