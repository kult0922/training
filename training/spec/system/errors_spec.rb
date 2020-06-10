require 'rails_helper'

RSpec.describe "Errors", type: :system do
  before do
    login(user)
  end

  let(:user) { FactoryBot.create(:user) }

  scenario 'forbidden' do
    allow(Task).to receive(:all).and_raise(ErrorHandlers::Forbidden)

    visit tasks_path

    expect(page).to have_content 'Forbidden'
    expect(page).to have_content '閲覧がブロックされました'
    expect(page.status_code).to eq 403
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
    allow(Task).to receive(:all).and_raise(Exception)
    visit tasks_path

    expect(page).to have_content 'Internal Server Error'
    expect(page).to have_content 'システムエラーが発生しました。時間を置いてお試しください'
    expect(page.status_code).to eq 500
  end
end
