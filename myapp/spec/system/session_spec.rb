require 'rails_helper'

RSpec.describe 'Session', js: true, type: :system do
  let!(:user) { create(:user) }

  it 'login' do
    visit root_path
    expect(current_path).to eq login_path

    visit_with_login root_path
    expect(current_path).to eq root_path
  end

  it 'logout' do
    visit_with_login root_path
    expect(current_path).to eq root_path
    expect(page).to have_link I18n.t('logout')

    click_link I18n.t('logout')
    expect(current_path).to eq login_path
  end

end
