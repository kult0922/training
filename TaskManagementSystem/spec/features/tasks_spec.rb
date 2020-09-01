require 'rails_helper'

RSpec.feature "Task", type: :feature do
  # タスク降順テスト
  feature 'TaskListDecendingOrder' do
    let!(:tasks){create_list(:valid_sample_task, 5)}
    scenario "is descending orders in task index screen" do
      # タスク一覧画面へ移動
      visit root_path

      # タスクが作成日時の降順になっていることを確認
      4.times do |n|
        expect(page.body.index(tasks[n].created_at.strftime('%Y/%m/%d'))).to be > page.body.index(tasks[n+1].created_at.strftime('%Y/%m/%d'))
      end
    end  
  end

  # 終了期限ソート機能テスト
  feature 'SortTaskListByDeadline' do
    let!(:tasks){create_list(:valid_sample_task, 5)}
    scenario "can sort task's list by deadline" do
      # タスク一覧画面へ移動
      visit root_path

      # 終了期限が新しい順になっている
      select('終了期限が新しい順', from: 'keyword')
      expect(page).to have_select('keyword', selected: '終了期限が新しい順')
      click_on('検索')
      4.times do |n|
        expect(page.body.index(tasks[n].deadline.strftime('%Y/%m/%d'))).to be > page.body.index(tasks[n+1].deadline.strftime('%Y/%m/%d'))
      end

      # 終了期限が古い順になっている
      select('終了期限が古い順', from: 'keyword')
      expect(page).to have_select('keyword', selected: '終了期限が古い順')
      click_on('検索')
      4.times do |n|
        expect(page.body.index(tasks[n].deadline.strftime('%Y/%m/%d'))).to be < page.body.index(tasks[n+1].deadline.strftime('%Y/%m/%d'))
      end
    end
  end
end
