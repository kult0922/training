# frozen_string_literal: true

require 'rails_helper'

describe 'Labels', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:another_user) { FactoryBot.create(:user) }
  let!(:label) { FactoryBot.create(:label, name: 'My Label', user: user) }

  shared_examples_for 'ページ名がラベル一覧になっている' do
    it { expect(page).to have_selector 'h1', text: 'ラベル一覧' }
  end

  describe '一覧表示' do
    context 'ラベルを登録しているユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        visit labels_path
      end

      it '全てのラベルが表示される' do
        expect(page).to have_content 'My Label'
      end

      it 'リンクが表示される' do
        expect(page).to have_link '編集'
        expect(page).to have_link '削除'
        expect(page).to have_link '新規作成'
        expect(page).to have_link 'タスク一覧'
        expect(page).to have_link 'ログアウト'
      end

      it_behaves_like 'ページ名がラベル一覧になっている'
    end

    context 'ラベルを登録していないユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: another_user.email
        fill_in 'パスワード', with: another_user.password
        click_button 'ログイン'
        visit labels_path
      end

      it '他のユーザーのラベルは表示されない' do
        expect(page).to have_no_content 'My Label'
      end
    end

    context 'ログインしていないとき' do
      before do
        visit labels_path
      end

      it 'ログインページにリダイレクトされる' do
        expect(page).to have_current_path new_session_path
      end
    end
  end

  describe '新規作成' do
    context 'ラベルを登録しているユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        visit new_label_path
        fill_in 'ラベル名', with: 'Important'
        click_button '作成する'
      end

      it '作成したタスクの属性を表示する' do
        expect(page).to have_content 'Important'
      end

      it 'flashメッセージが表示される' do
        expect(page).to have_selector '.notice', text: 'ラベルの作成が完了しました'
      end

      it_behaves_like 'ページ名がラベル一覧になっている'
    end

    context 'ログインしていないとき' do
      before do
        visit new_label_path
      end

      it 'ログインページにリダイレクトされる' do
        expect(page).to have_current_path new_session_path
      end
    end
  end

  describe '編集' do
    context 'ラベルを登録しているユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'
        visit edit_label_path(label)
        fill_in 'ラベル名', with: 'Your label'
        click_button '更新する'
      end

      it '更新後のラベルの属性を表示する' do
        expect(page).to have_content 'Your label'
      end

      it 'flashメッセージが表示される' do
        expect(page).to have_selector '.notice', text: 'ラベルの更新が完了しました'
      end

      it_behaves_like 'ページ名がラベル一覧になっている'
    end

    context 'タスクを登録していないユーザーがログインしているとき' do
      before do
        visit root_path
        fill_in 'メールアドレス', with: another_user.email
        fill_in 'パスワード', with: another_user.password
        click_button 'ログイン'
        visit edit_label_path(label)
      end

      it 'エラーが表示される' do
        expect(page).to have_current_path labels_path
        expect(page).to have_selector '.alert', text: 'データがありません'
      end
    end

    context 'ログインしていないとき' do
      before do
        visit edit_label_path(label)
      end

      it 'ログインページにリダイレクトされる' do
        expect(page).to have_current_path new_session_path
      end
    end
  end

  describe '削除' do
    before do
      visit root_path
      fill_in 'メールアドレス', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
      visit labels_path
      click_link '削除'
    end

    context '確認ダイアログでOKを選択する場合' do
      before do
        page.accept_confirm
      end

      it 'ラベルが削除されラベル名が表示されなくなる' do
        expect(page).to have_no_content 'My label'
      end

      it 'flashメッセージが表示される' do
        expect(page).to have_selector '.notice', text: 'ラベルの削除が完了しました'
      end

      it_behaves_like 'ページ名がラベル一覧になっている'
    end

    context '確認ダイアログでキャンセルを選択する場合' do
      before do
        page.dismiss_confirm
      end

      it 'ラベルが削除されていない' do
        expect(page).to have_content 'My Label'
      end

      it_behaves_like 'ページ名がラベル一覧になっている'
    end
  end
end
