require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  let!(:task) { create_list(:task, 5) }

  describe 'タスク一覧画面' do
    before do
      visit root_path
    end

    context '画面表示が正常' do
      example '表示されること' do
        expect(page).to have_content I18n.t('tasks.index.page_title')
      end

      example 'タスク登録ボタンが表示されること' do
        expect(page).to have_link I18n.t('tasks.index.submit_button')
      end

      example '並び順のセレクトボックスが表示されること' do
        expect(page).to have_select(I18n.t('tasks.index.sort_order'), selected: I18n.t('tasks.index.sort_create_at'), options: [I18n.t('tasks.index.sort_create_at'), I18n.t('tasks.index.sort_end_date')])
      end

      example '表示項目の確認 - 登録したステータスが表示されること' do
        td1 = all('tbody tr')[0].all('td')[0]
        expect(td1).to have_content task[4].status.to_s
      end

      example '表示項目の確認 - 登録したタスクが表示されること' do
        td2 = all('tbody tr')[0].all('td')[1]
        expect(td2).to have_content task[4].title.to_s
      end

      example '表示項目の確認 - 登録した終了期限が表示されること' do
        td3 = all('tbody tr')[0].all('td')[2]
        expect(td3).to have_content task[4].end_date.strftime('%Y/%m/%d').to_s
      end
    end

    context 'フォームの入力値が正常' do
      example '並び順が切り替わること' do
        # セレクトボックスを選択
        select I18n.t('tasks.index.sort_end_date'), from: 'q[sorts]'

        # セレクトボックスの変更をチェック
        expect(page).to have_select(I18n.t('tasks.index.sort_order'), selected: I18n.t('tasks.index.sort_end_date'))

        # セレクトボックスを選択
        select I18n.t('tasks.index.sort_create_at'), from: 'q[sorts]'

        # セレクトボックスの変更をチェック
        expect(page).to have_select(I18n.t('tasks.index.sort_order'), selected: I18n.t('tasks.index.sort_create_at'))
      end

      example 'ステータス「完了」を検索することで、完了のタスクが表示されること' do
        # セレクトボックスを選択
        select I18n.t('tasks.index.done'), from: 'q[status_eq]'

        click_button I18n.t('tasks.index.search')

        td1 = all('tbody tr')[0].all('td')[0]

        expect(td1).to have_content I18n.t('tasks.index.done')
      end

      example 'タスク名を検索することで、指定したタスク名のデータが取得できること' do
        # １行目の登録データのタスクタイトルを取得
        title_name = task[0].title

        # タスクタイトル名を入力
        fill_in I18n.t('tasks.index.search_task_name'), with: title_name

        click_button I18n.t('tasks.index.search')

        td1 = all('tbody tr')[0].all('td')[1]

        expect(td1).to have_content title_name
      end

      example '並び順を終了期限に変更することで、タスクの並び順が変わること' do
        # テーブル１行目
        date1_bf = all('tbody tr')[0].all('td')[2].text(:visible)
        # テーブル２行目
        date2_bf = all('tbody tr')[1].all('td')[2].text(:visible)
        # テーブル３行目
        date3_bf = all('tbody tr')[2].all('td')[2].text(:visible)
        # テーブル４行目
        date4_bf = all('tbody tr')[3].all('td')[2].text(:visible)
        # テーブル５行目
        date5_bf = all('tbody tr')[4].all('td')[2].text(:visible)

        # 終了期限が昇順で並んでいること
        expect(date5_bf).to be > date4_bf
        expect(date4_bf).to be > date3_bf
        expect(date3_bf).to be > date2_bf
        expect(date2_bf).to be > date1_bf

        # セレクトボックスを選択
        select I18n.t('tasks.index.sort_end_date'), from: 'select-sort'

        # URLの遷移をチェック
        expect(current_path).to eq '/2'

        # テーブル１行目
        date1_af = all('tbody tr')[0].all('td')[2].text(:visible)
        # テーブル２行目
        date2_af = all('tbody tr')[1].all('td')[2].text(:visible)
        # テーブル３行目
        date3_af = all('tbody tr')[2].all('td')[2].text(:visible)
        # テーブル４行目
        date4_af = all('tbody tr')[3].all('td')[2].text(:visible)
        # テーブル５行目
        date5_af = all('tbody tr')[4].all('td')[2].text(:visible)

        # 終了期限が降順で並んでいること
        expect(date1_af).to be > date2_af
        expect(date2_af).to be > date3_af
        expect(date3_af).to be > date4_af
        expect(date4_af).to be > date5_af
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
        expect(page).to have_content I18n.t('tasks.newtask.page_title')
      end
    end

    context 'フォームの入力値が正常' do
      example 'タスク登録に成功すること' do
        # ステータスで着手を選択
        select '着手', from: 'task[status]'

        # タイトルに「テストタイトル登録 from rspec」と入力
        fill_in I18n.t('activerecord.attributes.task.title'), with: 'テストタイトル登録 from rspec'

        # 内容に「テスト内容登録 from rspec」と入力
        fill_in I18n.t('activerecord.attributes.task.detail'), with: 'テスト内容登録 from rspec'

        # 終了期限を入力
        tommorow = Time.now + 1.day
        fill_in 'task[end_date]', with: tommorow.strftime('00%Y-%m-%d')

        # 送信ボタンをクリック
        click_button I18n.t('helpers.submit.create')

        # タスク一覧画面へ遷移することを期待する
        expect(current_path).to eq root_path

        # タスク一覧画面で登録成功のFlashメッセージが表示されることを確認する
        expect(page).to have_content I18n.t('msg.success_registration')
      end
    end

    context 'フォームの入力値が異常' do
      example 'タイトル・内容が未入力の時、エラーが表示されること' do
        # 送信ボタンをクリック
        click_button I18n.t('helpers.submit.create')

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.too_short')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.too_short')
      end

      example 'タイトルが未入力の時、エラーが表示されること' do
        # 内容に入力
        fill_in I18n.t('activerecord.attributes.task.detail'), with: 'テスト内容 from rspec'

        # 送信ボタンをクリック
        click_button I18n.t('helpers.submit.create')

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.too_short')
      end

      example '内容が未入力の時、エラーが表示されること' do
        # タイトルにと入力
        fill_in I18n.t('activerecord.attributes.task.title'), with: 'テストタイトル from rspec'

        # 送信ボタンをクリック
        click_button I18n.t('helpers.submit.create')

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.too_short')
      end

      example '入力文字数が３文字未満（タイトル）の時、エラーが表示されること' do
        # タイトルにと入力
        fill_in I18n.t('activerecord.attributes.task.title'), with: 'ab'

        # 内容に入力
        fill_in I18n.t('activerecord.attributes.task.detail'), with: 'abc'

        # 送信ボタンをクリック
        click_button I18n.t('helpers.submit.create')

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.too_short')
      end

      example '入力文字数が３文字未満（内容）の時、エラーが表示されること' do
        # タイトルにと入力
        fill_in I18n.t('activerecord.attributes.task.title'), with: 'abc'

        # 内容に入力
        fill_in I18n.t('activerecord.attributes.task.detail'), with: 'ab'

        # 送信ボタンをクリック
        click_button I18n.t('helpers.submit.create')

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.blank')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.too_short')
      end

      example 'タイトルの入力文字数が２０文字以上の時、エラーが表示されること' do
        # タイトルに「ab」と入力
        fill_in I18n.t('activerecord.attributes.task.title'), with: 'a' * 21

        # 内容にと入力
        fill_in I18n.t('activerecord.attributes.task.detail'), with: 'test'

        # 送信ボタンをクリック
        click_button I18n.t('helpers.submit.create')

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.title.too_long')
      end

      example '内容の入力文字数が２００文字以上の時、エラーが表示されること' do
        # タイトルに入力
        fill_in I18n.t('activerecord.attributes.task.title'), with: 'test'

        # 内容に入力
        fill_in I18n.t('activerecord.attributes.task.detail'), with: 'a' * 201

        # 送信ボタンをクリック
        click_button I18n.t('helpers.submit.create')

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content I18n.t('activerecord.errors.models.task.attributes.detail.too_long')
      end

      example '終了期限が過去の日付だった場合、エラーが表示されること' do

        # タイトルに「テストタイトル登録 from rspec」と入力
        fill_in I18n.t('activerecord.attributes.task.title'), with: 'テストタイトル登録 from rspec'

        # 内容に「テスト内容登録 from rspec」と入力
        fill_in I18n.t('activerecord.attributes.task.detail'), with: 'テスト内容登録 from rspec'

        # 過去の終了期限を入力
        yesterday = Time.now - 1.day
        fill_in 'task[end_date]', with: yesterday.strftime('00%Y-%m-%d')

        # 送信ボタンをクリック
        click_button I18n.t('helpers.submit.create')

        expect(page).to have_content I18n.t('tasks.newtask.error_title')
        expect(page).to have_content (I18n.t('activerecord.attributes.task.end_date') + I18n.t('msg.validate_end_date'))
      end
    end
  end

  describe 'タスク詳細画面' do
    context '画面表示が正常' do
      example 'タスク詳細画面が表示されること' do
        visit "tasks/taskdetail/#{task[0].id}"
        expect(page).to have_content I18n.t('tasks.taskdetail.page_title')
      end
    end
  end

  describe 'タスク更新画面' do
    before do
      # 更新画面へ遷移
      visit "tasks/taskupdate/#{task[0].id}"
    end

    context '画面表示が正常' do
      example 'タスク更新画面が表示されること' do
        expect(page).to have_content I18n.t('tasks.taskupdate.page_title')
      end
    end

    context 'フォームの入力値が正常' do
      example 'タスク更新に成功すること' do
        # タイトルに「テストタイトル更新 from rspec」と入力
        fill_in I18n.t('activerecord.attributes.task.title'), with: 'テストタイトル更新 from rspec'

        # 内容に「テスト詳細更新 from rspec」と入力
        fill_in I18n.t('activerecord.attributes.task.detail'), with: 'テスト詳細更新 from rspec'

        # 更新ボタンをクリック
        click_button I18n.t('helpers.submit.update')

        # タスク一覧画面へ遷移することを期待する
        expect(current_path).to eq root_path

        # タスク一覧画面で更新成功のFlashメッセージが表示されることを確認する
        expect(page).to have_content I18n.t('msg.success_update')
      end
    end
  end

  describe 'タスク削除画面' do
    context 'フォームの入力値が正常' do
      example 'タスク削除に成功すること' do
        # 詳細画面へ遷移
        visit "tasks/taskdetail/#{task[0].id}"

        # 削除ボタンをクリック
        click_link I18n.t('tasks.taskdetail.delete_button')

        # タスク一覧画面へ遷移することを期待する
        expect(current_path).to eq root_path

        # タスク一覧画面で削除成功のFlashメッセージが表示されることを確認する
        expect(page).to have_content I18n.t('msg.success_delete')
      end
    end
  end
end
