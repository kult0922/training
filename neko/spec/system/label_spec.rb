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

        expect(page).to have_current_path labels_path
        expect(page).to have_content 'ラベル一覧'
        expect(page).to have_content '名前'
        expect(page).to have_content 'タスク数'
        expect(page).to have_content '作成日時'
      end
    end
  end

  describe "#new (GET '/labels/new')" do
    context 'name is more than 2 letters' do
      it 'should be success to create a label' do
        visit new_label_path
        expect {
          fill_in '名前', with: 'label4'
          click_on '登録する'
        }.to change(Label, :count).by(1)

        expect(page).to have_current_path labels_path
        expect(page).to have_content 'ラベルを作成しました'
      end
    end

    context 'name is less than 2 letters' do
      it 'should be failure' do
        visit new_label_path
        expect {
          fill_in '名前', with: ''
          click_on '登録する'
        }.to change(Label, :count).by(0)

        expect(page).to have_content 'ラベルの作成に失敗しました'
        expect(page).to have_content '名前は2文字以上で入力してください'
      end
    end
  end

  describe "#edit (GET '/labels/:id/edit')" do
    before { visit edit_label_path(label1.id) }
    context 'name is more than 2 letters' do
      it 'should be success to update' do
        fill_in '名前', with: 'label5'

        click_on '更新する'
        expect(page).to have_current_path labels_path
        expect(page).to have_content 'ラベルを更新しました'
      end
    end

    context 'name is less than 2 letters' do
      it 'should be failure to update' do
        fill_in '名前', with: ''

        click_on '更新する'
        expect(page).to have_content 'ラベルの更新に失敗しました'
        expect(page).to have_content '名前は2文字以上で入力してください'
      end
    end
  end

  describe '#delete (DELETE /labels/:id)', js: true do
    before { visit labels_path }

    context 'delete a general label' do
      it 'able to cancel' do
        expect {
          page.dismiss_confirm 'ラベルを削除しますか？' do
            page.all('.label-delete a')[1].click
          end
          expect(page).to have_current_path labels_path
        }.to change(Label, :count).by(0)
      end

      it 'should be success to delete' do
        expect {
          page.accept_confirm 'ラベルを削除しますか？' do
            page.all('.label-delete a')[1].click
          end
          expect(page).to have_current_path labels_path
        }.to change(Label, :count).by(-1)

        expect(page).to have_content 'ラベルを削除しました'
      end
    end
  end
end
