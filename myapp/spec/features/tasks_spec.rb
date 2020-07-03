require 'rails_helper'
require 'capybara/rspec'

describe 'Task', type: :feature do
  let!(:task1) { create(:task, deadline: Time.zone.today, user: user) }
  let!(:task2) { create(:task, deadline: Time.zone.today + 1, user: user) }
  let!(:task3) { create(:task, deadline: Time.zone.today + 2, user: user) }
  let(:user) { create(:user) }
  let(:label) { create(:label) }
  let!(:task_label) { create(:task_label, task: task1, label: label) }
  before do
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: user.password
    click_on 'ログイン'
  end
  describe '#index' do
    context 'when opning index' do
      it 'The screen is displayed collectly' do
        visit tasks_path
        expect(page).to have_content 'Task一覧'
        expect(page).to have_content 'Title'
        expect(page).to have_content 'Memo'
        expect(page).to have_content 'Deadline'
        expect(page).to have_content 'Status'
        expect(page).to have_content 'ユーザー名'
        expect(page).to have_content 'ラベル'
      end
    end

    context 'when deadline is sorted' do
      it 'tasks are sorted in descending order' do
        visit '/tasks?sort=deadline+desc'
        task_array = all('.task')
        expect(task_array[0]).to have_content task3.deadline.strftime('%Y/%m/%d')
        expect(task_array[1]).to have_content task2.deadline.strftime('%Y/%m/%d')
        expect(task_array[2]).to have_content task1.deadline.strftime('%Y/%m/%d')
      end
    end

    context 'when task search' do
      it 'search by title' do
        visit tasks_path
        fill_in 'title', with: 'hoge'
        click_button 'Search'
        expect(page).to have_content 'hoge'
      end

      it 'search by status' do
        visit tasks_path
        select('完了', from: 'status')
        click_button 'Search'
        expect(page).to have_content '完了'
      end
      it 'search by label' do
        visit tasks_path
        select('priority', from: 'label_ids')
        click_button 'Search'
        label_all = all('.label')
        expect(label_all.size).to eq 1
      end
    end

    context 'when showing current_user', :skip_before do
      let(:current_user) { create(:user) }
      let!(:current_users_task) { create(:task, deadline: Time.zone.today, user: current_user) }
      it 'return current users tasks size' do
        visit login_path
        fill_in 'email', with: current_user.email
        fill_in 'password', with: current_user.password
        click_on 'ログイン'
        task_all = all('.task')
        expect(task_all.size).to eq 1
      end
    end
  end

  describe '#new' do
    context 'when creating task' do
      it 'task are saved' do
        visit new_task_path
        fill_in 'Title', with: 'huga'
        fill_in 'Memo', with: 'hogehoge'
        select_date('2020,10,10', from: 'Deadline')
        select('完了', from: 'Status')
        check 'priority'
        click_button '登録する'
        expect(page).to have_content 'Taskは正常に作成されました'
      end
    end
  end

  describe '#edit' do
    context 'when editing task' do
      it 'task are updated' do
        visit edit_task_path(task1)

        fill_in 'Title', with: 'test'
        fill_in 'Memo', with: 'testtest'
        select_date('2020,10,10', from: 'Deadline')
        select('着手中', from: 'Status')
        uncheck 'priority'

        click_button '更新する'
        expect(page).to have_content 'Taskは正常に更新されました'
      end
    end
  end

  describe '#show' do
    context 'when opning task' do
      it 'returns task' do
        visit task_path(task1)

        expect(page).to have_content 'Task詳細'
        expect(page).to have_content task1.title
        expect(page).to have_content task1.memo
        expect(page).to have_content task1.deadline.strftime('%Y/%m/%d')
        expect(page).to have_content label.name
        expect(page).to have_content '完了'
      end
    end
  end

  describe '#delete' do
    context 'when task is deleted' do
      it 'redirect_to index' do
        visit task_path(task1)

        click_on 'Delete'
        expect(page).to have_content 'Taskは正常に削除されました'
      end
    end
  end

  describe 'paginate' do
    let!(:tasks) { create_list(:task, 17, user: user) }
    context 'when 2 button clicked' do
      it 'show 5 and 10 task' do
        visit tasks_path
        click_on '2'
        expect(page).to have_content tasks[2].title
        expect(page).to have_content tasks[6].title
      end
    end
    context 'when end button clicked' do
      it 'show 16 and 20 task' do
        visit tasks_path
        click_on '最後'
        expect(page).to have_content tasks[12].title
        expect(page).to have_content tasks[16].title
      end
    end
  end
end
