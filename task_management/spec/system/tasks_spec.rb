# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:test_name) { 'test_task_2' }
  let(:test_details) { 'test2_description' }
  let(:test_deadline) { Time.zone.now + 3.days }
  let(:test_priority) { Task.priorities.key(1) }
  let(:test_status) { Task.statuses.key(2) }
  let!(:test_authority) { create(:authority, id: 1, role: 0, name: 'test') }
  let!(:test_index_user) { create(:user, id: 1, login_id: 'yokuno', authority_id: test_authority.id) }
  let!(:added_index_task) { create(:task, id: 2, creation_date: Time.current + 5.days, user_id: test_index_user.id) }
  let!(:test_user) { create(:user, id: 2, login_id: 'test_user_2', authority_id: test_authority.id) }
  let!(:added_task) { create(:task, creation_date: Time.current + 1.days, user_id: test_user.id) }
  before {
    allow_any_instance_of(ActionDispatch::Request)
      .to receive(:session).and_return(user_id: test_index_user.id)
  }

  describe '#index' do
    before { visit root_path }
    context 'トップページにアクセスした場合' do
      example 'タスク一覧が表示される' do
        expect(page).to have_content added_task.name
      end
    end

    context '編集リンクを押下した場合' do
      example 'タスク編集画面に遷移する' do
        click_link '編集'
        expect(page).to have_content 'タスク編集'
      end
    end

    context '削除ボタンを押下した場合' do
      example 'タスクを削除できる' do
        page.accept_confirm do
          click_button '削除'
        end
        expect(page).to have_content '削除しました。'
      end
    end

    describe 'search' do
      let!(:taskC) {
        create(:task, id: 5, name:'taskC', creation_date: Time.current + 2.days,
                      user_id: test_index_user.id, deadline: Time.current + 4.days,
                      status: 1)
      }
      let!(:taskD) {
        create(:task, id: 6, name:'taskD', creation_date: Time.current + 2.days,
                      user_id: test_index_user.id, deadline: Time.current + 4.days,
                      status: 2)
      }
      let!(:taskE) {
        create(:task, id: 7, name:'taskE', creation_date: Time.current + 2.days,
                      user_id: test_index_user.id, deadline: Time.current + 4.days,
                      status: 3)
      }
      context '検索キーワードを入力し、検索ボタンを押下した場合' do
        before do
          fill_in 'search_word', with: 'task'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content 'test_task_1'
          expect(page).to have_content 'taskC'
          expect(page).to have_content 'taskD'
          expect(page).to have_content 'taskE'
        end
      end

      context 'ステータス「全て」を選択し、検索ボタンを押下した場合' do
        before do
          choose 'all'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content 'test_task_1'
          expect(page).to have_content 'taskC'
          expect(page).to have_content 'taskD'
          expect(page).to have_content 'taskE'
        end
      end

      context 'ステータス｢未着手」を選択し、検索ボタンを押下した場合' do
        before do
          choose 'todo'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content 'taskC'
        end
      end

      context 'ステータス「着手」を選択し、検索ボタンを押下した場合' do
        before do
          choose 'in_progress'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content 'taskD'
        end
      end

      context 'ステータス「完了」を選択し、検索ボタンを押下した場合' do
        before do
          choose 'done'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content 'taskE'
        end
      end

      context 'ステータス「着手」と検索キーワードを入力し、検索ボタンを押下した場合' do
        before do
          choose 'in_progress'
          fill_in 'search_word', with: 'task'
        end
        example 'タスクを検索できる' do
          click_button '検索'
          expect(page).to have_content 'taskD'
        end
      end

    end

    describe 'sorting' do
      let!(:taskA) { 
        create(:task, id: 3, name:'taskA', creation_date: Time.current + 2.days,
                      user_id: test_index_user.id, deadline: Time.current + 4.days)
      }      
      let!(:taskB) { 
        create(:task, id: 4, name:'taskB', creation_date: Time.current + 3.days,
                      user_id: test_index_user.id, deadline: Time.current + 1.days)
      }      
      before do
        visit root_path
      end
      context 'トップページにアクセスした場合（サーバ側で「作成日時」を降順ソート）' do
        example '「作成日時」で降順ソートされた状態で表示される' do
          expect(page.body.index(taskA.name)).to be > page.body.index(taskB.name)
        end
      end

      context '「終了期限」のソートリンクを押下した場合' do
        example '「終了期限」で降順ソートされた状態で表示される' do
          click_link 'deadline_desc'
          sleep 1
          expect(page.body.index(taskB.name)).to be > page.body.index(taskA.name)
        end
      end

    end
  end

  describe '#show(task_id)' do
    context '詳細ページにアクセスした場合' do
      example 'タスク詳細が表示される' do
        visit task_path(added_task)
        expect(page).to have_content added_task.name
      end
    end
  end

  describe '#new' do
    before { visit new_task_path }
    context '全項目を入力し、登録ボタンを押下した場合' do
      before do
        fill_in 'name', with: test_name
        fill_in 'details', with: test_details
        fill_in 'deadline', with: test_deadline
        select '中', from: 'task[priority]'
        select '着手', from: 'task[status]'
      end
      example 'タスクを登録できる' do
        click_button '登録'
        expect(page).to have_content '登録が完了しました。'
      end
    end

    context '必須項目を入力せず、登録ボタンを押下した場合' do
      before do
        fill_in 'name', with: ''
        fill_in 'details', with: test_details
        fill_in 'deadline', with: test_deadline
        select '中', from: 'task[priority]'
        select '着手', from: 'task[status]'
      end
      example 'タスクが登録できない' do
        click_button '登録'
        expect(page).to have_content '登録に失敗しました。'
      end
    end
  end

  describe '#edit' do
    before { visit edit_task_path(added_task) }
    context '全項目を入力し、更新ボタンを押下した場合' do
      before do
        fill_in 'name', with: test_name
      end
      example 'タスクを更新できる' do
        click_button '更新'
        expect(page).to have_content '更新が完了しました。'
      end
    end

    context '必須項目を入力せず、更新ボタンを押下した場合' do
      before do
        fill_in 'name', with: ''
      end
      example 'タスクが更新できない' do
        click_button '更新'
        expect(page).to have_content '更新に失敗しました。'
      end
    end
  end

  describe '404' do
    context '存在しないパスにアクセスした場合' do
      example '404ページを表示する' do
        visit task_path('test404')
        expect(page).to have_content 'お探しのページは見つかりませんでした。'
      end
    end
  end

  describe '500' do
    context 'サーバエラーが発生した場合' do
      example '500ページを表示する' do
        allow_any_instance_of(TasksController).to receive(:index).and_throw(Exception)
        visit tasks_path
        expect(page).to have_content '大変申し訳ありません。一時的なエラーが発生しました。'
      end
    end
  end

end
