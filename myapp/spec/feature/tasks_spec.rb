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
      expect(all('tbody tr').count > 1).to be_truthy
      expect(all('tbody tr').first.text).to have_content task_new.title
    end
  end
end
