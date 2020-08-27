# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :feature do
  let!(:task) { create(:task) }
  let!(:task_new) { create(:task, created_at: Time.zone.tomorrow) }

  before do
    visit root_path
  end

  context 'When there are multiple tasks' do
    it 'check sort by created_at desc' do
      expect(all('tbody tr')[0].text).to have_content task_new.title
      expect(all('tbody tr')[1].text).to have_content task.title
    end
  end
end
