require 'rails_helper'

RSpec.describe "Errors", type: :system do
  before do
    Rails.env = 'production'
  end

  scenario 'activerecord record not found' do
    visit task_path(id: 'xxx')

    expect(page).to have_content 'Page Not Found'
    expect(page).to have_content 'お探しのページが存在しません'
    expect(page.status_code).to eq 404
  end

  scenario 'page not found' do
    visit '/tasks/404test'

    expect(page).to have_content 'Page Not Found'
    expect(page).to have_content 'お探しのページが存在しません'
    expect(page.status_code).to eq 404
  end

  scenario 'internal server error' do
    allow_any_instance_of(TasksController).to receive(:index).and_throw(Exception)
    visit tasks_path

    expect(page).to have_content 'Internal Server Error'
    expect(page).to have_content 'システムエラーが発生しました。時間を置いてお試しください'
    expect(page.status_code).to eq 500
  end
end
