# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, js: true, type: :system do
  before { travel_to(Time.zone.local(2020, 12, 24, 21, 0o0, 0o0)) }
  let(:sample_task_name) { 'やらなきゃいけないサンプル' }
  let(:sample_task_description) { 'やらなきゃいけないサンプル説明文' }
  let(:sample_task_status) { 'todo' }
  let(:now) { Time.current }
  let(:today) { Time.zone.today }
  let!(:sample_task) {
    create(:task,
           name: sample_task_name,
           description: sample_task_description,
           created_at: now,
           target_date: today, status: sample_task_status)
  }

  describe '#index' do
    let!(:sample_task_2) { create(:task, created_at: now + 2.days, target_date: today - 1.day) }
    let!(:sample_task_3) { create(:task, created_at: now + 1.day, target_date: today + 1.day) }
    let(:sort_ids_by_created_at) { sort_task_ids(:created_at) }
    let(:sort_ids_by_target_date) { sort_task_ids(:target_date) }
    before { visit tasks_path }
    def sort_task_ids(key)
      [sample_task, sample_task_2, sample_task_3]
        .sort_by(&key).reverse
        .map { |t| t.id.to_s }
    end

    it 'tasks are sorted by created_at desc' do
      ids = page.all('tbody td')
                .map(&:text)
                .select { |td_context| sort_ids_by_created_at.include?(td_context) }

      expect(ids).to eq(sort_ids_by_created_at)
    end

    context 'when click 完了日' do
      before do
        click_on '完了日'
        # 表示が完了する前にクローリングが走ってしまうので、待機する
        sleep(1)
      end

      it 'tasks are sorted by target_date desc' do
        ids = page.all('tbody td')
                  .map(&:text)
                  .select { |td_context| sort_ids_by_target_date.include?(td_context) }

        expect(ids).to eq(sort_ids_by_target_date)
      end
    end
  end

  describe '#show' do
    it 'visit show page' do
      visit task_path id: sample_task.id
      expect(page).to have_content sample_task_name
    end
  end

  describe '#new' do
    before { visit new_task_path }

    context 'submit valid values' do
      let(:create_task_name) { 'これから作るタスクの名前' }
      let(:create_task_description) { 'これから作るタスクの説明文' }
      let(:create_task_target_date) { today + 3.days }

      before do
        fill_in 'タスク名', with: create_task_name
        fill_in '説明文', with: create_task_description
        [create_task_target_date.year,
         create_task_target_date.month,
         create_task_target_date.day].each_with_index.each do |v, i|
          find("#task_target_date_#{i + 1}i").find("option[value='#{v}']").select_option
        end
      end

      subject { click_button '作成' }

      it 'move to task list page' do
        subject
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'タスクを作成したよ'
      end

      it 'create new task' do
        expect { subject }.to change(Task, :count).by(1)
        created_task = Task.last
        expect(created_task.name).to eq(create_task_name)
        expect(created_task.description).to eq(create_task_description)
        expect(created_task.target_date).to eq(create_task_target_date)
      end
    end
  end

  describe '#edit' do
    before { visit edit_task_path id: sample_task.id }

    context 'submit valid values' do
      let(:update_task_name) { '更新するタスクの名前' }
      let(:update_task_description) { '更新するタスクの説明文' }
      let(:update_task_target_date) { today + 3.days }
      let(:update_task_status) { 'doing' }
      let(:updated_task) { Task.find(sample_task.id) }
      before do
        fill_in 'タスク名', with: update_task_name
        fill_in '説明文', with: update_task_description
        find('#task_status').find("option[value='#{update_task_status}']").select_option
        [update_task_target_date.year,
         update_task_target_date.month,
         update_task_target_date.day].each_with_index.each do |v, i|
          find("#task_target_date_#{i + 1}i").find("option[value='#{v}']").select_option
        end
      end

      subject { click_button '更新' }

      it 'move to task updated task page' do
        expect { subject }.to change {
          current_path
        }.from(edit_task_path(id: sample_task.id))
         .to(task_path(id: sample_task.id))
        expect(page).to have_content 'タスクを更新したよ'
      end

      it 'update selected task' do
        expect { subject }.to change {
          updated_task.reload
          updated_task.name
        }.from(sample_task_name).to(update_task_name)
          .and change {
            updated_task.description
          }.from(sample_task_description).to(update_task_description)
          .and change {
            updated_task.target_date
          }.from(today).to(update_task_target_date)
          .and change {
            updated_task.status
          }.from(sample_task_status).to(update_task_status)
      end
    end
  end

  describe '#destroy' do
    before { visit task_path id: sample_task.id }

    subject do
      page.accept_confirm do
        click_on '削除'
      end
    end

    it 'move to task list page' do
      subject
      expect(current_path).to eq tasks_path
      expect(page).to have_content 'タスクを削除したよ'
    end

    it 'delete selected task' do
      expect { subject }.to change {
        # 削除処理の前にカウントのSQLが走ってしまうため、待機する。
        sleep 0.1
        Task.count
      }.by(-1)
    end
  end
end
