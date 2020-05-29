require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  scenario '#create' do
    visit new_task_path

    fill_in 'タイトル', with: 'title test'
    fill_in '詳細', with: 'description test'
    select '中', from: '優先度'
    select '着手中', from: 'ステータス'
    select Time.now.year, from: 'task_due_date_1i'
    select Time.now.month + 1, from: 'task_due_date_2i'
    select Time.now.day, from: 'task_due_date_3i'
    click_button '登録する'

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content 'タスクが作成されました'
    expect(page).to have_content 'title test'
  end

  scenario '#update' do
    task = FactoryBot.create(:task)

    visit edit_task_path(task)

    fill_in 'タイトル', with: 'edit title test'
    fill_in '詳細', with: 'edit description test'
    select '高', from: '優先度'
    select '未着手', from: 'ステータス'
    select '2020', from: 'task_due_date_1i'
    select '6月', from: 'task_due_date_2i'
    select '2', from: 'task_due_date_3i'
    click_button '更新する'

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content 'タスクが更新されました'
    expect(page).to have_content 'edit title test'
  end

  scenario '#show' do
    task = FactoryBot.create(:task)

    visit tasks_path

    click_link '詳細'

    expect(current_path).to eq(task_path(task))
    expect(page).to have_content 'task title'
    expect(page).to have_content 'task description'
    expect(page).to have_content '低'
    expect(page).to have_content '未着手'
    expect(page).to have_content I18n.l(task.due_date, format: :short)
  end

  scenario '#delete' do
    task = FactoryBot.create(:task)

    visit tasks_path

    click_link '削除'

    expect(current_path).to eq(tasks_path)
    expect(page).to have_content 'タスクが削除されました'
    expect(page).not_to have_content 'task title'
  end

  scenario 'in descending order of created_at' do
    tasks = FactoryBot.create_list(:task, 5, :with_order_by_created_at)

    visit tasks_path

    expect(page.body.index(I18n.l(tasks[0].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[1].created_at, format: :long))
    expect(page.body.index(I18n.l(tasks[1].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[2].created_at, format: :long))
    expect(page.body.index(I18n.l(tasks[2].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[3].created_at, format: :long))
    expect(page.body.index(I18n.l(tasks[3].created_at, format: :long))).to be < page.body.index(I18n.l(tasks[4].created_at, format: :long))
  end

  scenario 'in descending order of due_date' do
    tasks = FactoryBot.create_list(:task, 5, :with_order_by_due_date)

    visit tasks_path
    select '降順', from: 'due_date_order'
    click_button '検索する'

    expect(page.body.index(I18n.l(tasks[4].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[3].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[3].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[2].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[2].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[1].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[1].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[0].due_date, format: :short))
  end

  scenario 'in ascending order of due_date' do
    tasks = FactoryBot.create_list(:task, 5, :with_order_by_due_date)

    visit tasks_path
    select '昇順', from: 'due_date_order'
    click_button '検索する'

    expect(page.body.index(I18n.l(tasks[0].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[1].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[1].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[2].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[2].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[3].due_date, format: :short))
    expect(page.body.index(I18n.l(tasks[3].due_date, format: :short))).to be < page.body.index(I18n.l(tasks[4].due_date, format: :short))
  end

  describe 'search' do
    before do
      FactoryBot.create(:task, title: 'tiger elephant gorilla', status: 'working')
      FactoryBot.create(:task, title: 'rabbit rat', status: 'done')
      FactoryBot.create(:task, title: 'bear elephant', status: 'working')
      FactoryBot.create(:task, title: 'monkey', status: 'waiting')
      FactoryBot.create(:task, title: 'zebra deer', status: 'done')
    end

    # テーブル最上部のラベル行も件数に含むので全レコード - 1
    let(:record_count) { all('table tr').size - 1 }
    context 'have record' do
      context 'title and status is blank' do
        scenario 'all record' do
          visit tasks_path
          fill_in 'title', with: ''
          select '昇順', from: 'due_date_order'
          click_button '検索する'

          expect(record_count).to eq(5)
        end
      end

      context 'title is present and status is blank' do
        scenario 'is 2 records' do
          visit tasks_path
          fill_in 'title', with: 'elephant'
          select '昇順', from: 'due_date_order'
          click_button '検索する'

          expect(record_count).to eq(2)
          expect(page).to have_content 'tiger elephant gorilla'
          expect(page).to have_content 'bear elephant'
        end
      end

      context 'title is blank and status is present' do
        scenario 'is 2 records' do
          visit tasks_path
          select '完了', from: 'status'
          select '昇順', from: 'due_date_order'
          click_button '検索する'

          expect(record_count).to eq(2)
          expect(page).to have_content '完了'
        end
      end

      context 'title is present and status is present' do
        scenario 'is 2 records' do
          visit tasks_path
          fill_in 'title', with: 'elephant'
          select '着手中', from: 'status'
          select '昇順', from: 'due_date_order'
          click_button '検索する'

          expect(record_count).to eq(2)
          expect(page).to have_content 'tiger elephant gorilla'
          expect(page).to have_content 'bear elephant'
          expect(page).to have_content '着手中'
        end
      end
    end

    context 'have not record' do
      scenario 'is none record' do
        visit tasks_path
        fill_in 'title', with: 'dog'
        select '着手中', from: 'status'
        select '昇順', from: 'due_date_order'
        click_button '検索する'

        expect(record_count).to eq(0)
      end
    end

    context 'raise error' do
      scenario 'display error message' do
        allow(Task).to receive(:search_by_status).and_raise

        visit tasks_path
        fill_in 'title', with: 'elephant'
        select '着手中', from: 'status'
        select '昇順', from: 'due_date_order'
        click_button '検索する'

        expect(current_path).to eq(tasks_path)
        expect(page).to have_content '検索でエラーが発生しました。時間を置いて再度お試しください'
      end
    end
  end
end
