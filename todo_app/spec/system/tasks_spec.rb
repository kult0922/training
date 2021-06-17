require 'rails_helper'

RSpec.describe 'Tasks', type: :sytem do
  let!(:task) { create(:task) }

  describe '#index' do
    it 'vist tasks/index' do
      visit root_path

      expect(current_path).to eq root_path

      expect(page).to have_content(task.title)
      expect(page).to have_content(task.description)
    end
  end

  describe '#new' do
    let!(:title) { Faker::Alphanumeric.alphanumeric(number: 10) }
    let!(:desc) { Faker::Alphanumeric.alphanumeric(number: 10) }

    it 'create task' do
      visit new_task_path
  
      fill_in 'Title', with: title
      fill_in 'Description', with: desc

      expect do
        click_button '新規作成'
      end.to change(Task, :count).by(1)

      expect(current_path).to eq root_path

      expect(page).to have_content('登録成功')
      expect(page).to have_content(title)
      expect(page).to have_content(desc)
    end
  end

  describe '#edit' do
    let!(:title) { Faker::Alphanumeric.alphanumeric(number: 10) }
    let!(:desc) { Faker::Alphanumeric.alphanumeric(number: 10) }

    it 'update task' do
      visit edit_task_path(task)

      expect(current_path).to eq edit_task_path(task)

      expect(page).to have_field 'Title', with: task.title
      expect(page).to have_field 'Description', with: task.description

      fill_in 'Title', with: title
      fill_in 'Description', with: desc

      expect do
        click_button '更新'
      end.to change(Task, :count).by(0)
  
      expect(current_path).to eq task_path(task)

      expect(page).to have_content('更新成功')
      expect(page).to have_content(title)
      expect(page).to have_content(desc)
    end
  end

  describe '#show' do
    it 'visit show' do
      visit task_path(task)

      expect(current_path).to eq task_path(task)

      expect(page).to have_content(task.title)
      expect(page).to have_content(task.description)
    end
  end

  describe '#destroy' do
    it 'delete record' do
      visit task_path(task)

      expect(current_path).to eq task_path(task)

      expect do
        click_link '削除'
      end.to change(Task, :count).by(-1)

      expect(current_path).to eq root_path

      expect(page).to have_content('削除成功')
      expect(page).to_not have_content(task.title)
      expect(page).to_not have_content(task.description)
    end
  end
end
