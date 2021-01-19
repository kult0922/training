# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :system do
  let(:test_name) { 'test_task_2' }
  let(:test_details) { 'test2_description' }
  let(:test_deadline) { Time.zone.now + 3.days }
  let(:test_priority) { Task.priorities.key(1) }
  let(:test_status) { Task.statuses.key(1) }
  let!(:test_authority) do
    create(:authority,
           id: 1,
           role: 0,
           name: 'test')
  end
  let!(:test_index_user) do
    create(:user,
           id: 1,
           login_id: 'yokuno',
           authority_id: test_authority.id)
  end
  let!(:added_index_task) do
    create(:task,
           user_id: test_index_user.id)
  end
  let!(:test_user) do
    create(:user,
           id: 2,
           login_id: 'test_user_2',
           authority_id: test_authority.id)
  end
  let!(:added_task) do
    create(:task,
           user_id: test_user.id)
  end

  describe '#index' do
    context 'トップページにアクセスした場合' do
      example 'タスク一覧が表示される' do
        visit root_path
        expect(current_path).to eq root_path
        expect(page).to have_content added_task.name
      end
    end

    context '編集リンクを押下した場合' do
      before { visit root_path }
      example 'タスク編集画面に遷移する' do
        click_link '編集'
        expect(page).to have_content 'タスク編集'
      end
    end

    context '削除ボタンを押下した場合' do
      before { visit root_path }
      example 'タスクを削除できる' do
        page.accept_confirm do
          click_button '削除'
        end
        expect(page).to have_content '削除しました。'
      end
    end

    describe 'sorting' do
      let!(:taskA) do
        create(:task, name: 'taskA',
                      creation_date: Time.current + 2.days,
                      user_id: test_index_user.id,
                      deadline: Time.current + 4.days)
      end
      let!(:taskB) do
        create(:task, name: 'taskB',
                      creation_date: Time.current + 3.days,
                      user_id: test_index_user.id,
                      deadline: Time.current + 1.day)
      end
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
    context 'タスク詳細画面にアクセスした場合' do
      example 'タスク詳細画面が表示される' do
        visit task_path(added_index_task)
        expect(current_path).to eq task_path(added_index_task)
      end
    end
  end

  describe '#new' do
    before { visit new_task_path }
    context 'タスク登録画面にアクセスした場合' do
      example 'タスク登録画面が表示される' do
        expect(current_path).to eq new_task_path
      end
    end

    context '全項目を入力して登録ボタンを押下した場合' do
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
    context 'タスク編集画面にアクセスした場合' do
      example 'タスク編集画面が表示される' do
        expect(current_path).to eq edit_task_path(added_task)
      end
    end

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
end
