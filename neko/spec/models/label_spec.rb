require 'rails_helper'

describe 'lebel', type: :system do
  let!(:user1) { create(:user, name: 'user1') }
  let!(:auth1) { create(:auth, user: user1) }
  let!(:label1) { create(:label) }

  before do
    visit '/login'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'testpassword'
    click_on 'ログイン'
  end

  describe '#index' do
    context 'accress root' do
      it 'should be success to access the task list' do
        visit labels_path

        expect(page).to have_content '名前'
        expect(page).to have_content 'タスク数'
        expect(page).to have_content '作成日時'
      end
    end

  end

  describe '#new' do
    before { visit new_label_path(label1.id) }

    context 'name is more than one letter' do
      it 'should be success to create' do
        fill_in '名前', with: 'ラベルA'

        click_on '登録する'
        expect(page).to have_content 'ラベルを作成しました'
      end
    end

    context 'name is blank' do
      it 'should be failure to create' do
        fill_in '名前', with: ''

        click_on '登録する'
        expect(page).to have_content 'ラベルの作成に失敗しました'
      end
    end
  end

  describe '#edit' do
    context 'name is more than one letter' do
      it 'should be success to update' do
        visit edit_label_path(label1.id)
        fill_in '名前', with: 'ラベルB'

        click_on '更新する'
        expect(page).to have_content 'ラベルを更新しました'
      end
    end
  end

  describe '#delete', js: true do
    context 'push delete button' do
      it 'should be success to delete the label' do
        visit labels_path

        page.accept_confirm do
          click_on '削除', match: :first
        end
        expect(page).to have_content 'ラベルを削除しました'
      end
    end
  end
  
end
