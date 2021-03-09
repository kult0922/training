# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task) { create_list(:task, 10) }

  describe '#task' do
    it 'index' do
      visit root_path({ direction: 'desc', sort: 'created_at' })

      9.times do |i|
        expect(page.find_by_id("created_at-#{i}").text).to be > page.find_by_id("created_at-#{i + 1}").text
      end
    end

    it 'sort' do
      visit root_path({ direction: 'desc', sort: 'created_at' })

      find('#created_at').click
      9.downto(1) do |i|
        expect(page.find_by_id("created_at-#{i}").text).to be > page.find_by_id("created_at-#{i - 1}").text
      end

      find('#created_at').click
      9.times do |i|
        expect(page.find_by_id("created_at-#{i}").text).to be > page.find_by_id("created_at-#{i + 1}").text
      end
    end

    it 'create' do
      visit new_task_path
      fill_in 'task_title', with: 'title'
      fill_in 'task_detail', with: 'detail'

      click_button '登録する'
      expect(page).to have_content'title'
    end

    it 'update' do
      task = create(:task)
      visit edit_task_path(task)

      fill_in 'task_title', with: 'sample'
      expect(page).to have_field 'task_detail', with: 'detail'
      click_button '更新する'

      expect(page).to have_content 'sample'
    end
  end
end
