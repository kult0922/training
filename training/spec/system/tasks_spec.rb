require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  scenario '#create' do
    visit new_task_path

    fill_in 'Title', with: 'title test'
    fill_in 'Description', with: 'description test'
    select 'medium', from: 'Priority'
    select 'working', from: 'Status'
    select '2019', from: 'task_due_date_1i'
    select 'January', from: 'task_due_date_2i'
    select '1', from: 'task_due_date_3i'
    click_button '送信'

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content 'タスクが作成されました'
  end

  scenario '#update' do
    task = FactoryBot.create(:task)

    visit edit_task_path(task)

    fill_in 'Title', with: 'edit title test'
    fill_in 'Description', with: 'edit description test'
    select 'high', from: 'Priority'
    select 'waiting', from: 'Status'
    select '2020', from: 'task_due_date_1i'
    select 'July', from: 'task_due_date_2i'
    select '2', from: 'task_due_date_3i'
    click_button '送信'

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content 'タスクが更新されました'
  end

  scenario '#show' do
    task = FactoryBot.create(:task)

    visit tasks_path

    click_link 'show'

    expect(current_path).to eq(task_path(task))
    expect(page).to have_content 'title'
    expect(page).to have_content 'description'
    expect(page).to have_content 'low'
    expect(page).to have_content 'waiting'
    expect(page).to have_content '2019年04月14日'
  end

  scenario '#delete' do
    task = FactoryBot.create(:task)

    visit tasks_path

    click_link 'delete'

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content 'タスクが削除されました'
  end
end
