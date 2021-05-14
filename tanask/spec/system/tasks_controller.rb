require 'rails_helper'

RSpec.describe 'TasksControllers', type: :system do
  describe 'GET /index' do
    before do
      Task.create(name: 'hoge', description: 'fuga')
    end

    it 'GET / index' do
      visit '/tasks'
      take_screenshot
      # expect(response.success?).to be_success
      expect(page).to have_content('hoge')
    end
  end
end

