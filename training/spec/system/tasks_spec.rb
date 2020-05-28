require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  scenario '#create' do
    visit new_task_path

    fill_in 'タイトル', with: 'title test'
    fill_in '詳細', with: 'description test'
    select '中', from: '優先度'
    select '着手中', from: 'ステータス'
    select Time.now.year, from: 'task_due_date_1i'
    select Time.now.month + 1, from: 'task_due_date_2i'
    select Time.now.day, from: 'task_due_date_3i'
    click_button '登録する'

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content 'タスクが作成されました'
    expect(page).to have_content 'title test'
  end

  scenario '#update' do
    task = FactoryBot.create(:task)

    visit edit_task_path(task)

    fill_in 'タイトル', with: 'edit title test'
    fill_in '詳細', with: 'edit description test'
    select '高', from: '優先度'
    select '未着手', from: 'ステータス'
    select '2020', from: 'task_due_date_1i'
    select '6月', from: 'task_due_date_2i'
    select '2', from: 'task_due_date_3i'
    click_button '更新する'

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content 'タスクが更新されました'
    expect(page).to have_content 'edit title test'
  end

  scenario '#show' do
    task = FactoryBot.create(:task)

    visit tasks_path

    click_link '詳細'

    expect(current_path).to eq(task_path(task))
    expect(page).to have_content 'task title'
    expect(page).to have_content 'task description'
    expect(page).to have_content '低'
    expect(page).to have_content '未着手'
    expect(page).to have_content I18n.l(task.due_date, format: :short)
  end

  scenario '#delete' do
    task = FactoryBot.create(:task)

    visit tasks_path

    click_link '削除'

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content 'タスクが削除されました'
    expect(page).not_to have_content 'task title'
  end

  scenario 'in descending order of created_at' do
    tasks = FactoryBot.create_list(:task, 5, :with_order_by_created_at)

    visit tasks_path

    expect(page.body.index(I18n.l(tasks[0].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[1].created_at, format: :long))
    expect(page.body.index(I18n.l(tasks[1].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[2].created_at, format: :long))
    expect(page.body.index(I18n.l(tasks[2].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[3].created_at, format: :long))
    expect(page.body.index(I18n.l(tasks[3].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[4].created_at, format: :long))
  end

  scenario 'in descending order of due_date' do
    tasks = FactoryBot.create_list(:task, 5, :with_order_by_due_date)

    visit tasks_path
    select '降順', from: 'due_date_order'
    click_button '検索する'

    expect(page.body.index(I18n.l(tasks[0].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[1].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[1].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[2].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[2].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[3].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[3].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[4].due_date, format: :short))
  end

  scenario 'in ascending order of due_date' do
    tasks = FactoryBot.create_list(:task, 5, :with_order_by_due_date)

    visit tasks_path
    select '昇順', from: 'due_date_order'
    click_button '検索する'

    expect(page.body.index(I18n.l(tasks[4].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[3].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[3].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[2].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[2].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[1].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[1].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[0].due_date, format: :short))
  end
end
