# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :system do
  let(:user) { create(:user) }
  let!(:label) { create(:label) }

  describe '#index' do
    before do
      login(user)
      visit labels_path
    end

    context 'when visit index page' do
      it 'should have label' do
        expect(page).to have_content 'ラベル'
        expect(page).to have_content 'label_1'
        expect(page).to have_content '作成日'
        expect(page).to have_content '修正'
        expect(page).to have_content '削除'
        expect(page).to have_content 'ラベル追加'
      end
    end
  end

  describe '#new' do
    before do
      login(user)
      visit new_label_path
    end

    context 'when create label' do
      it 'is created' do
        find_by(id: 'label_color').execute_script('this.value = arguments[0]', '#d37864')
        fill_in 'label_text', with: 'label_test'
        click_on '登録する'

        expect(page).to have_content 'label_test'
        expect(Label.find_by(text: 'label_test').color).to eq '#d37864'
      end
    end

    context 'when text not input' do
      it 'should be error' do
        click_on '登録する'

        expect(page).to have_content 'ラベルの作成に失敗しました。'
        expect(page).to have_content 'ラベル内容を入力してください'
      end
    end
  end

  describe '#edit' do
    before do
      login(user)
      visit edit_label_path(label)
    end

    context 'when edit label' do
      it 'is changed' do
        find_by(id: 'label_color').execute_script('this.value = arguments[0]', '#d37864')
        fill_in 'label_text', with: 'edit_test'
        click_on '更新する'

        expect(page).to have_content 'edit_test'
        expect(Label.find_by(text: 'edit_test').color).to eq '#d37864'
      end
    end

    context 'when text not input' do
      it 'should be error' do
        fill_in 'label_text', with: ''
        click_on '更新する'

        expect(page).to have_content 'ラベルの更新に失敗しました。'
        expect(page).to have_content 'ラベル内容を入力してください'
      end
    end
  end

  describe '#destroy' do
    before do
      login(user)
      visit labels_path
    end

    context 'when delete label' do
      it 'is deleted' do
        click_link '削除', href: label_path(label.id)
        expect(page.driver.browser.switch_to.alert.text).to eq '削除してもよろしいでしょうか?'
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'ラベルが削除されました。'
      end
    end
  end
end
