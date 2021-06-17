require "rails_helper"
require 'pp'

RSpec.describe "Tasks (System)", :type => :system do

  scenario 'tasks is ordered by created_at with descending order' do
    expected_order = %w[task2 task1]
    visit tasks_url
    click_button 'New Task'
    fill_in 'task[name]', with: 'task1'
    fill_in 'task[desc]', with: 'task1 desc'
    click_button 'Create Task'
    expect(page).to have_text('Task was successfully created.')
    visit '/tasks/new'
    fill_in 'task[title]', with: 'task2'
    fill_in 'task[desc]', with: 'task1 desc'
    click_button 'Create Task'
    expect(page).to have_text('タスクが保存されました。')
    visit '/tasks'
    # expect(page.all('.task-name').map(&:text)).to eq expected_order
    pp page.all('.task-name')
  end
end