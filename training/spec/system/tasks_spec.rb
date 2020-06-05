require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  include LoginSupport

  before do
    login(user)
  end

  let(:user) { FactoryBot.create(:user) }

  scenario '#create' do
    visit new_task_path

    fill_in 'task_title', with: 'title test'
    fill_in 'task_description', with: 'description test'
    select Task.priorities_i18n['medium'], from: 'task_priority'
    select Task.statuses_i18n['working'], from: 'task_status'
    select Time.now.year, from: 'task_due_date_1i'
    select Time.now.month + 1, from: 'task_due_date_2i'
    select Time.now.day, from: 'task_due_date_3i'
    click_button I18n.t('helpers.submit.create')

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content I18n.t('tasks.flash.create')
    expect(page).to have_content 'title test'
  end

  scenario '#update' do
    task = FactoryBot.create(:task, user: user)

    visit edit_task_path(task)

    fill_in 'task_title', with: 'edit title test'
    fill_in 'task_description', with: 'edit description test'
    select Task.priorities_i18n['hight'], from: 'task_priority'
    select Task.statuses_i18n['waiting'], from: 'task_status'
    select Time.now.year, from: 'task_due_date_1i'
    select Time.now.month + 1, from: 'task_due_date_2i'
    select Time.now.day, from: 'task_due_date_3i'
    click_button I18n.t('helpers.submit.update')

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content I18n.t('tasks.flash.update')
    expect(page).to have_content 'edit title test'
  end

  scenario '#show' do
    task = FactoryBot.create(:task, user: user)

    visit tasks_path

    click_link I18n.t('tasks.link.show')

    expect(current_path).to eq(task_path(task))
    expect(page).to have_content 'task title'
    expect(page).to have_content 'task description'
    expect(page).to have_content Task.priorities_i18n['low']
    expect(page).to have_content Task.statuses_i18n['waiting']
    expect(page).to have_content I18n.l(task.due_date, format: :short)
  end

  scenario '#delete' do
    task = FactoryBot.create(:task, user: user)

    visit tasks_path

    click_link I18n.t('tasks.link.delete')

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content I18n.t('tasks.flash.delete')
    expect(page).not_to have_content 'task title'
  end

  scenario 'in descending order of created_at' do
    tasks = FactoryBot.create_list(:task, 5, :with_order_by_created_at, user: user)

    visit tasks_path

    expect(page.body.index(I18n.l(tasks[0].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[1].created_at, format: :long))
    expect(page.body.index(I18n.l(tasks[1].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[2].created_at, format: :long))
    expect(page.body.index(I18n.l(tasks[2].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[3].created_at, format: :long))
    expect(page.body.index(I18n.l(tasks[3].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[4].created_at, format: :long))
  end

  scenario 'in descending order of due_date' do
    tasks = FactoryBot.create_list(:task, 5, :with_order_by_due_date, user: user)

    visit tasks_path
    select I18n.t('tasks.search_form.due_date_order_desc'), from: 'due_date_order'
    click_button I18n.t('tasks.search_form.button')

    expect(page.body.index(I18n.l(tasks[4].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[3].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[3].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[2].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[2].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[1].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[1].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[0].due_date, format: :short))
  end

  scenario 'in ascending order of due_date' do
    tasks = FactoryBot.create_list(:task, 5, :with_order_by_due_date, user: user)

    visit tasks_path
    select I18n.t('tasks.search_form.due_date_order_asc'), from: 'due_date_order'
    click_button I18n.t('tasks.search_form.button')

    expect(page.body.index(I18n.l(tasks[0].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[1].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[1].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[2].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[2].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[3].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[3].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[4].due_date, format: :short))
  end

  describe 'search' do
    before do
      FactoryBot.create(:task, title: 'tiger elephant gorilla', status: 'working', user: user)
      FactoryBot.create(:task, title: 'rabbit rat', status: 'done', user: user)
      FactoryBot.create(:task, title: 'bear elephant', status: 'working', user: user)
      FactoryBot.create(:task, title: 'monkey', status: 'waiting', user: user)
      FactoryBot.create(:task, title: 'zebra deer', status: 'done', user: user)
    end

    # テーブル最上部のラベル行も件数に含むので全レコード - 1
    let(:record_count) { all('table tr').size - 1 }
    context 'have record' do
      context 'title and status is blank' do
        scenario 'all record' do
          visit tasks_path
          fill_in 'title', with: ''
          select I18n.t('tasks.search_form.due_date_order_asc'), from: 'due_date_order'
          click_button I18n.t('tasks.search_form.button')

          expect(record_count).to eq(5)
        end
      end

      context 'title is present and status is blank' do
        scenario 'is 2 records' do
          visit tasks_path
          fill_in 'title', with: 'elephant'
          select I18n.t('tasks.search_form.due_date_order_asc'), from: 'due_date_order'
          click_button I18n.t('tasks.search_form.button')

          expect(record_count).to eq(2)
          expect(page).to have_content 'tiger elephant gorilla'
          expect(page).to have_content 'bear elephant'
        end
      end

      context 'title is blank and status is present' do
        scenario 'is 2 records' do
          visit tasks_path
          select Task.statuses_i18n['done'], from: 'status'
          select I18n.t('tasks.search_form.due_date_order_asc'), from: 'due_date_order'
          click_button I18n.t('tasks.search_form.button')

          expect(record_count).to eq(2)
          expect(page).to have_content Task.statuses_i18n['done']
        end
      end

      context 'title is present and status is present' do
        scenario 'is 2 records' do
          visit tasks_path
          fill_in 'title', with: 'elephant'
          select Task.statuses_i18n['working'], from: 'status'
          select I18n.t('tasks.search_form.due_date_order_asc'), from: 'due_date_order'
          click_button I18n.t('tasks.search_form.button')

          expect(record_count).to eq(2)
          expect(page).to have_content 'tiger elephant gorilla'
          expect(page).to have_content 'bear elephant'
          expect(page).to have_content Task.statuses_i18n['working']
        end
      end
    end

    context 'have not record' do
      scenario 'is none record' do
        visit tasks_path
        fill_in 'title', with: 'dog'
        select Task.statuses_i18n['working'], from: 'status'
        select I18n.t('tasks.search_form.due_date_order_asc'), from: 'due_date_order'
        click_button I18n.t('tasks.search_form.button')

        expect(record_count).to eq(0)
      end
    end

    context 'raise error' do
      scenario 'display error message' do
        allow(Task).to receive(:search_by_status).and_raise

        visit tasks_path
        fill_in 'title', with: 'elephant'
        select Task.statuses_i18n['working'], from: 'status'
        select I18n.t('tasks.search_form.due_date_order_asc'), from: 'due_date_order'
        click_button I18n.t('tasks.search_form.button')

        expect(current_path).to eq(tasks_path)
        expect(page).to have_content '検索でエラーが発生しました。時間を置いて再度お試しください'
      end
    end
  end
end
