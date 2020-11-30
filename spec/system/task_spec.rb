require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  let!(:task) { create(:task) }

  describe 'タスク一覧画面' do
    before do
      visit root_path
    end

    context '画面表示が正常' do
      example '表示されること' do
        expect(page).to have_content I18n.t("tasks.index.page_title")
      end

      example 'タスク登録ボタンが表示されること' do
        expect(page).to have_link 'タスク登録'
      end

      example '並び順のセレクトボックスが表示されること' do
        expect(page).to have_select('並び順:', selected: '作成日', options: ['作成日', '終了期限'])
      end

      example '表示項目の確認 - 登録したステータスが表示されること' do
        td1 = all('tbody tr')[0].all('td')[0]
        expect(td1).to have_content "#{task.status}"
      end

      example '表示項目の確認 - 登録したタスクが表示されること' do
        td2 = all('tbody tr')[0].all('td')[1]
        expect(td2).to have_content "#{task.title}"
      end

      example '表示項目の確認 - 登録した終了期限が表示されること' do
        td3 = all('tbody tr')[0].all('td')[2]
        expect(td3).to have_content "#{task.end_date.strftime('%Y/%m/%d')}"
      end
    end

    context 'フォームの入力値が正常' do
      it '並び順を選択' do
        # セレクトボックスを選択
        select '終了期限', from: 'select-sort'

        # セレクトボックスの変更をチェック
        expect(page).to have_select('並び順:', selected: '終了期限')

        # URLの遷移をチェック
        expect(current_path).to eq '/2'

        # セレクトボックスを選択
        select '作成日', from: 'select-sort'

        # セレクトボックスの変更をチェック
        expect(page).to have_select('並び順:', selected: '作成日')

        # URLの遷移をチェック
        expect(current_path).to eq '/'
      end
    end
  end

  describe 'タスク登録画面' do
    before do
      # 登録画面へ遷移
      visit tasks_newtask_path
    end

    context '画面表示が正常' do
      example 'タスク登録画面が表示されること' do
        expect(page).to have_content I18n.t("tasks.newtask.page_title")
      end
    end

    context 'フォームの入力値が正常' do
      example 'タスク登録に成功すること' do

        # ステータスで着手を選択
        select '着手', from: 'task[status]'

        # タイトルに「テストタイトル登録 from rspec」と入力
        fill_in 'タイトル', with: 'テストタイトル登録 from rspec'

        # 内容に「テスト内容登録 from rspec」と入力
        fill_in '内容', with: 'テスト内容登録 from rspec'

        # 送信ボタンをクリック
        click_button I18n.t("helpers.submit.create")

        # タスク一覧画面へ遷移することを期待する
        expect(current_path).to eq root_path

        # タスク一覧画面で登録成功のFlashメッセージが表示されることを確認する
        expect(page).to have_content I18n.t("msg.success_registration")
      end
    end

    context 'フォームの入力値が異常' do
      example 'タイトル・内容が未入力の時、エラーが表示されること' do
        # 送信ボタンをクリック
        click_button I18n.t("helpers.submit.create")

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.too_short')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.too_short')
      end

      example 'タイトルが未入力の時、エラーが表示されること' do
        # 内容に入力
        fill_in '内容', with: 'テスト内容 from rspec'

        # 送信ボタンをクリック
        click_button I18n.t("helpers.submit.create")

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.too_short')
      end

      example '内容が未入力の時、エラーが表示されること' do
        # タイトルにと入力
        fill_in 'タイトル', with: 'テストタイトル from rspec'

        # 送信ボタンをクリック
        click_button I18n.t("helpers.submit.create")

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.too_short')
      end

      example '入力文字数が３文字未満（タイトル）の時、エラーが表示されること' do
        # タイトルにと入力
        fill_in 'タイトル', with: 'ab'

        # 内容に入力
        fill_in '内容', with: 'abc'

        # 送信ボタンをクリック
        click_button I18n.t("helpers.submit.create")

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.too_short')
      end

      example '入力文字数が３文字未満（内容）の時、エラーが表示されること' do
        # タイトルにと入力
        fill_in 'タイトル', with: 'abc'

        # 内容に入力
        fill_in '内容', with: 'ab'

        # 送信ボタンをクリック
        click_button I18n.t("helpers.submit.create")

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.too_short')
      end

      example 'タイトルの入力文字数が２０文字以上の時、エラーが表示されること' do
        # タイトルに「ab」と入力
        fill_in 'タイトル', with: 'a' * 21

        # 内容にと入力
        fill_in '内容', with: 'test'

        # 送信ボタンをクリック
        click_button I18n.t("helpers.submit.create")

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.too_long')
      end

      example '内容の入力文字数が２００文字以上の時、エラーが表示されること' do
        # タイトルに入力
        fill_in 'タイトル', with: 'test'

        # 内容に入力
        fill_in '内容', with: 'a' * 201

        # 送信ボタンをクリック
        click_button I18n.t("helpers.submit.create")

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.too_long')
      end
    end
  end

  describe 'タスク詳細画面' do
    context '画面表示が正常' do
      example 'タスク詳細画面が表示されること' do
        visit "tasks/taskdetail/#{task.id}"
        expect(page).to have_content I18n.t("tasks.taskdetail.page_title")
      end
    end
  end

  describe 'タスク更新画面' do
    before do
      # 更新画面へ遷移
      visit "tasks/taskupdate/#{task.id}"
    end

    context '画面表示が正常' do
      example 'タスク更新画面が表示されること' do
        expect(page).to have_content I18n.t("tasks.taskupdate.page_title")
      end
    end

    context 'フォームの入力値が正常' do
      example 'タスク更新に成功すること' do
        # タイトルに「テストタイトル更新 from rspec」と入力
        fill_in 'タイトル', with: 'テストタイトル更新 from rspec'

        # 内容に「テスト詳細更新 from rspec」と入力
        fill_in '内容', with: 'テスト詳細更新 from rspec'

        # 更新ボタンをクリック
        click_button I18n.t("helpers.submit.update")

        # タスク一覧画面へ遷移することを期待する
        expect(current_path).to eq root_path

        # タスク一覧画面で更新成功のFlashメッセージが表示されることを確認する
        expect(page).to have_content I18n.t("msg.success_update")
      end
    end
  end

  describe 'タスク削除画面' do
    context 'フォームの入力値が正常' do
      example 'タスク削除に成功すること' do
        # 詳細画面へ遷移
        visit "tasks/taskdetail/#{task.id}"

        # 削除ボタンをクリック
        click_link I18n.t("tasks.taskdetail.delete_button")

        # タスク一覧画面へ遷移することを期待する
        expect(current_path).to eq root_path

        # タスク一覧画面で削除成功のFlashメッセージが表示されることを確認する
        expect(page).to have_content I18n.t("msg.success_delete")
      end
    end
  end
end
