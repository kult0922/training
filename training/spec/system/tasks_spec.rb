require 'rails_helper'

RSpec.describe "Tasks", type: :system, js: true do
  scenario '#create' do
    visit new_task_path

    fill_in 'Title', with: 'title test'
    fill_in 'Description', with: 'description test'
    click_button '送信'

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content 'タスクが作成されました'
    # 続きのhave_content
  end
end
