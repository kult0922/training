require 'rails_helper'

RSpec.describe "TasksControllers", type: :system do
  describe "GET /index" do
    it 'show list page' do
      visit 'tasks/index'
      # expect(responce).to be_success
    end
  end
end

