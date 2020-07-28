require 'rails_helper'

RSpec.describe 'Labels', type: :system do
  let!(:user) { create(:user) }
  let!(:label) { create(:label, user_id: user.id) }

  before do
    visit login_path
    fill_in 'session_mail_address', with: user.mail_address
    fill_in 'session_password', with: user.password
    click_on 'ログイン'
  end

  describe '#index' do
    it '登録済みラベル一覧が表示される' do
      visit labels_path
      expect(page).to have_content 'ラベル名'
      expect(page).to have_content '作成日時'
      expect(page).to have_content label.name
    end
  end

  describe '#create' do
    before do
      visit new_label_path
    end

    context '正常な値が入力された場合' do
      it 'ラベル一覧画面に遷移し、新規ラベルが一覧に表示されている' do
        fill_in 'label_name', with: 'new_label'
        click_on '登録'
        expect(current_path).to eq(labels_path)
        expect(page).to have_content 'new_label'
      end
    end

    context '異常な値が入力された場合' do
      context 'ラベル名が空欄の場合' do
        it 'ラベル名を入力してくださいとのメッセージが表示される' do
          fill_in 'label_name', with: ''
          click_on '登録'
          expect(page).to have_content 'ラベル名を入力してください'
        end
      end

      context 'ラベル名に最大文字数を超過した値が入力された場合' do
        it 'ラベル名は10文字以内で入力してくださいとのメッセージが表示される' do
          fill_in 'label_name', with: '012345678901'
          click_on '登録'
          expect(page).to have_content 'ラベル名は10文字以内で入力してください'
        end
      end
    end
  end

  describe '#update' do
    before do
      visit edit_label_path(label.id)
    end

    context '正常な値が入力された場合' do
      it 'ラベル一覧画面に遷移し、新規ラベルが一覧に表示されている' do
        fill_in 'label_name', with: 'new_label'
        click_on '更新'
        expect(current_path).to eq(labels_path)
        expect(page).to have_content 'new_label'
      end
    end

    context '異常な値が入力された場合' do
      context 'ラベル名が空欄の場合' do
        it 'ラベル名を入力してくださいとのメッセージが表示される' do
          fill_in 'label_name', with: ''
          click_on '更新'
          expect(page).to have_content 'ラベル名を入力してください'
        end
      end

      context 'ラベル名に最大文字数を超過した値が入力された場合' do
        it 'ラベル名は10文字以内で入力してくださいとのメッセージが表示される' do
          fill_in 'label_name', with: '012345678901'
          click_on '更新'
          expect(page).to have_content 'ラベル名は10文字以内で入力してください'
        end
      end
    end
  end

  describe '#destroy' do
    before do
      visit labels_path
    end

    it 'ダイアログが表示される' do
      page.dismiss_confirm do
        click_link '削除'
        expect(page.driver.browser.switch_to.alert.text).to eq '削除しますか？'
      end
    end

    it '削除したラベルが一覧画面に表示されていない且つ、ラベルの削除が成功したとのメッセージが表示される' do
      page.accept_confirm do
        click_link '削除'
      end
      expect(page).not_to have_content label.name
      expect(page).to have_content 'ラベルを削除しました'
    end
  end
end
