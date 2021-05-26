# frozen_string_literal: true

require 'rails_helper'

describe 'Tasks', type: :system do
  let!(:first_task) {
    FactoryBot.create(:task,
                      title: 'First task',
                      description: 'Submit documents',
                      priority: 2,
                      aasm_state: :doing)
  }
  let!(:second_task) {
    FactoryBot.create(:task,
                      title: 'Second task',
                      description: 'Take e-learning',
                      priority: 1,
                      aasm_state: :done)
  }

  shared_examples_for 'ページ名がタスク一覧になっている' do
    it { expect(page).to have_selector 'h1', text: 'タスク一覧' }
  end

  shared_examples_for 'ページ名がタスク詳細になっている' do
    it { expect(page).to have_selector 'h1', text: 'タスク詳細' }
  end

  describe '一覧表示' do
    before do
      visit root_path
    end

    it '全てのタスクが表示される' do
      expect(page).to have_content 'First task'
      expect(page).to have_content 'Second task'
    end

    it '優先順位順に表示される' do
      expect(page.body.index(second_task.title)).to be < page.body.index(first_task.title)
    end

    it 'リンクが表示される' do
      expect(page).to have_link '詳細'
      expect(page).to have_link '編集'
      expect(page).to have_link '削除'
      expect(page).to have_link '新規作成'
    end

    it 'ボタンが表示される' do
      expect(page).to have_button '絞り込む'
    end

    it_behaves_like 'ページ名がタスク一覧になっている'
  end

  describe '詳細表示' do
    before do
      visit task_path(first_task)
    end

    it 'タスクの属性を表示する' do
      expect(page).to have_content 'First task'
      expect(page).to have_content 'Submit documents'
    end

    it 'リンクが表示される' do
      expect(page).to have_link '編集'
      expect(page).to have_link '戻る'
    end

    it_behaves_like 'ページ名がタスク詳細になっている'
  end

  describe '新規作成' do
    before do
      visit new_task_path
      fill_in '優先順位', with: 3
      fill_in 'タスク名', with: 'Third task'
      fill_in 'タスク詳細', with: 'Introduce myself'
      click_button '作成する'
    end

    it '作成したタスクの属性を表示する' do
      expect(page).to have_content 'Third task'
      expect(page).to have_content 'Introduce myself'
    end

    it 'flashメッセージが表示される' do
      expect(page).to have_selector '.notice', text: 'タスクの作成が完了しました'
    end

    it_behaves_like 'ページ名がタスク詳細になっている'
  end

  describe '編集' do
    before do
      visit edit_task_path(first_task)
      fill_in 'タスク名', with: '1st Task'
      fill_in 'タスク詳細', with: 'Submit papers'
      click_button '更新する'
    end

    it '更新後のタスクの属性を表示する' do
      expect(page).to have_content '1st Task'
      expect(page).to have_content 'Submit papers'
    end

    it 'flashメッセージが表示される' do
      expect(page).to have_selector '.notice', text: 'タスクの更新が完了しました'
    end

    it_behaves_like 'ページ名がタスク詳細になっている'
  end

  describe '削除' do
    before do
      second_task.destroy # '削除'のリンクを1つにしたいので、対象のタスクを１つにしておく
      visit root_path
      click_link '削除'
    end

    context '確認ダイアログでOKを選択する場合' do
      before do
        page.accept_confirm
      end

      it 'タスクが削除され属性が表示されなくなる' do
        expect(page).to have_no_content 'First task'
        expect(page).to have_no_content 'Submit documents'
      end

      it 'ページの名前が表示される' do
        expect(page).to have_selector 'h1', text: 'タスク一覧'
      end

      it 'flashメッセージが表示される' do
        expect(page).to have_selector '.notice', text: 'タスクの削除が完了しました'
      end

      it_behaves_like 'ページ名がタスク一覧になっている'
    end

    context '確認ダイアログでキャンセルを選択する場合' do
      before do
        page.dismiss_confirm
      end

      it 'タスクが削除されていない' do
        expect(page).to have_content 'First task'
        expect(page).to have_content 'Submit documents'
      end

      it_behaves_like 'ページ名がタスク一覧になっている'
    end
  end

  describe '検索' do
    before do
      FactoryBot.create(:task,
                        title: 'Third task',
                        description: 'Create account',
                        priority: 3,
                        aasm_state: :ready)
      FactoryBot.create(:task,
                        title: 'First job',
                        description: 'Setup environment',
                        priority: 4,
                        aasm_state: :ready)
      visit root_path
    end

    context 'ステータスで検索する場合' do
      before do
        select '未着手', from: 'q[aasm_state_eq]'
        click_button '絞り込む'
      end

      it '未着手のタスクのみが表示される' do
        expect(page).to have_content 'Third task'
        expect(page).to have_content 'First job'
        expect(page).to have_no_content 'Second task'
        expect(page).to have_no_content 'First task'
      end
    end

    context 'タスク名で検索する場合' do
      before do
        fill_in 'q[title_cont]', with: 'First'
        click_button '絞り込む'
      end

      it '指定したタスク名のタスクのみが表示される' do
        expect(page).to have_content 'First job'
        expect(page).to have_content 'First task'
        expect(page).to have_no_content 'Third task'
        expect(page).to have_no_content 'Second task'
      end
    end

    context 'タスク名とステータスで検索する場合' do
      before do
        fill_in 'q[title_cont]', with: 'First'
        select '未着手', from: 'q[aasm_state_eq]'
        click_button '絞り込む'
      end

      it '指定した条件のタスクのみが表示される' do
        expect(page).to have_content 'First job'
        expect(page).to have_no_content 'First task'
        expect(page).to have_no_content 'Third task'
        expect(page).to have_no_content 'Second task'
      end
    end
  end

  describe 'ステータス変更' do
    before do
      FactoryBot.create(:task,
                        title: 'Third task',
                        description: 'Create account',
                        priority: 3,
                        aasm_state: :ready)
      visit root_path
    end

    it 'ボタンが表示される' do
      trs = page.all('tbody tr')
      expect(trs[1]).to have_button '完了する'
      expect(trs[2]).to have_button '着手する'
    end

    context '「完了する」ボタンを押す場合' do
      before do
        click_button '完了する'
        page.accept_confirm
      end

      it '「完了する」ボタンがなくなりステータスが完了になる' do
        trs = page.all('tbody tr')
        expect(trs[1]).to have_no_button '完了する'
        expect(trs[1]).to have_no_content '着手'
        expect(trs[1]).to have_content '完了'
      end
    end

    context '「着手する」ボタンを押す場合' do
      before do
        click_button '着手する'
        page.accept_confirm
      end

      it '「着手する」ボタンが「完了する」ボタンになり、ステータスが着手になる' do
        trs = page.all('tbody tr')
        expect(trs[2]).to have_no_button '着手する'
        expect(trs[2]).to have_button '完了する'
        expect(trs[2]).to have_no_content '未着手'
        expect(trs[2]).to have_content '着手'
      end
    end
  end
end
