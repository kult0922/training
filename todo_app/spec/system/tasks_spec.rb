require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  before do
    @task = Task.create!(title: 'タイトル1', description: '説明1')
  end

  it 'タスク一覧が表示されているか' do
    visit tasks_path

    expect(page).to have_content 'タイトル1'
    expect(page).to have_content '説明1'
  end

  it 'タスク詳細が表示されるか' do
    visit task_path(@task)

    expect(page).to have_content 'タイトル1'
    expect(page).to have_content '説明1'
  end

  it 'タスクを変更できるか' do
    visit edit_task_path(@task)

    fill_in 'task_title', with: 'hoge'
    fill_in 'task_description', with: 'fuga'
    click_button I18n.t(:'button.edit')
    expect(page).to have_content 'hoge'
    expect(page).to have_content 'fuga'
  end

  it 'タスクが削除できるか' do
    visit tasks_path

    click_link I18n.t(:'link.delete')
    expect(page).to have_content I18n.t(:'message.deleted_task')
    expect(page).to have_content I18n.t(:'message.task_not_registered')
  end
end
