# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:user) { create(:user) }
  let!(:task) { create_list(:task, 10, user_id: user.id) }

  before 'login' do
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_button 'ログイン'
  end

  describe '#task' do
    it 'index' do
      visit tasks_path({ direction: 'desc', sort: 'created_at' })

      4.times do |i|
        expect(page.find_by_id("created_at-#{i}").text).to be > page.find_by_id("created_at-#{i + 1}").text
      end
    end

    it 'sort' do
      visit tasks_path({ direction: 'desc', sort: 'created_at' })

      # asc
      click_link '作成日時'
      sleep 2
      4.downto(1) do |i|
        expect(page.find_by_id("created_at-#{i}").text).to be > page.find_by_id("created_at-#{i - 1}").text
      end

      # desc
      click_link '作成日時'
      4.times do |i|
        expect(page.find_by_id("created_at-#{i}").text).to be > page.find_by_id("created_at-#{i + 1}").text
      end
    end

    it 'search' do
      create(:task, title: 'picktitle', user_id: user.id)
      visit tasks_path

      fill_in 'search_title', with: 'pick'
      click_button '検索'

      expect(page).to have_content 'picktitle'
    end

    it 'create' do
      visit new_task_path
      fill_in 'task_title', with: 'title'
      fill_in 'task_detail', with: 'detail'

      click_button '登録する'
      expect(page).to have_content 'title'
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
