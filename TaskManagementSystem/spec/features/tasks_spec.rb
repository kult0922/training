require 'rails_helper'

RSpec.feature "Task", type: :feature do
  # タスク降順テスト
  feature 'TaskListDecendingOrder' do
    let!(:user){create(:login_user)}
    let!(:tasks){create_list(:valid_sample_task, 5, user_id: user.id)}
    scenario "is descending orders in task index screen" do
      # ログイン画面へ移動
      visit login_path

      # ログインフォームへ入力
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'サインイン'

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
    let!(:user){create(:login_user)}
    let!(:tasks){create_list(:valid_sample_task, 5, user_id: user.id)}
    scenario "can sort task's list by deadline" do
      # ログイン画面へ移動
      visit login_path

      # ログインフォームへ入力
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'サインイン'

      # ログインができている
      expect(page).to have_content 'ログインしました。'
      
      # タスク一覧画面へ移動
      visit root_path

      # 終了期限が新しい順になっている
      select('新しい順', from: 'deadline_keyword')
      expect(page).to have_select('deadline_keyword', selected: '新しい順')
      click_on('検索')
      4.times do |n|
        expect(page.body.index(tasks[n].deadline.strftime('%Y/%m/%d'))).to be > page.body.index(tasks[n+1].deadline.strftime('%Y/%m/%d'))
      end

      # 終了期限が古い順になっている
      select('古い順', from: 'deadline_keyword')
      expect(page).to have_select('deadline_keyword', selected: '古い順')
      click_on('検索')
      4.times do |n|
        expect(page.body.index(tasks[n].deadline.strftime('%Y/%m/%d'))).to be < page.body.index(tasks[n+1].deadline.strftime('%Y/%m/%d'))
      end
    end
  end

  # タスク名とステータスで検索ができる
  feature 'SearchTaskListByTitleAndStatus' do
    let!(:user){create(:login_user)}
    3.times do |n|
      let!(:valid_task) {create(:valid_sample_task, status: n, user_id: user.id)}
    end
    # タスク名での検索ができる
    scenario 'can search tasks by title' do
      # ログイン画面へ移動
      visit login_path

      # ログインフォームへ入力
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'サインイン'

      # ログインができている
      expect(page).to have_content 'ログインしました。'

      # タスク一覧画面へ移動
      visit root_path

      # 検索フォームへ入力
      fill_in 'title_keyword', with: 'タスク名のテスト1'
      click_button '検索'

      # 検索結果が表示されている
      expect(page).to have_content 'タスク名のテスト1'
    end

    # ステータスでの検索ができる
    scenario 'can search tasks by status' do
      # ログイン画面へ移動
      visit login_path

      # ログインフォームへ入力
      fill_in 'email', with: user.email
      fill_in 'password', with: user.password
      click_button 'サインイン'

      # ログインができている
      expect(page).to have_content 'ログインしました。'

      # タスク一覧画面へ移動
      visit root_path

      # 検索フォームへ入力
      select('未着手', from: 'status_keyword')
      click_button '検索'

      # 検索結果が表示されている
      expect(page).to have_content '完了'
    end
  end
end
