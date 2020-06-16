require 'rails_helper'

describe 'label', type: :system do
  let!(:user1) { create(:user, name: 'user1') }
  let!(:auth1) { create(:auth, user: user1) }
  let!(:label1) { create(:label, name: 'label1') }
  let!(:label2) { create(:label, name: 'label2') }
  let!(:label3) { create(:label, name: 'label3') }

  before do
    visit '/login'
    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'testpassword'
    click_on 'ログイン'
  end

  describe "#index(GET '/labels/')" do
    context 'accress labels_path' do
      it 'should be success to access the task list' do
        visit labels_path

        expect(page).to have_content 'ラベル一覧'
        expect(page).to have_content '名前'
        expect(page).to have_content 'タスク数'
        expect(page).to have_content '作成日時'
      end
    end
  end

  describe "#new (GET '/labels/new')" do
    context 'create new label' do
      it 'should be success' do
        visit new_label_path

        fill_in '名前', with: 'label4'
        click_on '登録する'
        expect(page).to have_content 'ラベルを作成しました'
      end
    end

    context 'name is blank' do
      it 'should be failure' do
        visit new_label_path

        fill_in '名前', with: ''
        click_on '登録する'
        expect(page).to have_content 'ラベルの作成に失敗しました'
      end
    end
  end

  describe "#edit (GET '/labels/:id/edit')" do
    before { visit edit_label_path(label1.id) }
    context 'information is correct' do
      it 'should be success to update' do
        fill_in '名前', with: 'label5'

        click_on '更新する'
        expect(page).to have_content 'ラベルを更新しました'
      end
    end

    context 'name is blank' do
      it 'should be failure to update' do
        fill_in '名前', with: ''

        click_on '更新する'
        expect(page).to have_content 'ラベルの更新に失敗しました'
      end
    end
  end

  describe '#delete (DELETE /labels/:id)', js: true do
    before { visit labels_path }

    context 'delete a general label' do
      it 'should be success to delete ' do
        # confirm dialog
        page.accept_confirm do
          page.all('.label-delete a')[1].click
        end
        expect(page).to have_content 'ラベルを削除しました'
      end
    end
  end
end
