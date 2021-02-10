# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validation' do
    let(:test_authority) { create(:authority) }
    let(:login_id) { 'test_login' }
    let(:name) { 'test_name' }
    let(:password) { 'pass' }
    let(:authority_id) { test_authority.id }

    subject do
      build(
        :user,
        login_id: login_id,
        name: name,
        password: password,
        authority_id: authority_id,
      )
    end

    context 'ログインID、ユーザ名、パスワード、権限IDが有る場合' do
      example '登録できる' do
        is_expected.to be_valid
      end
    end

    context 'ログインIDが無い場合' do
      let(:login_id) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context 'ユーザ名が無い場合' do
      let(:name) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context 'パスワードが無い場合' do
      let(:password) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context '権限IDが無い場合' do
      let(:authority_id) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context 'ログインIDが重複する場合' do
      let!(:test_user) do
        create(:user,
               login_id: 'test_login',
               name: 'test_name_2',
               password: 'test_pass_2',
               authority_id: test_authority.id)
      end
      let(:login_id) { test_user.login_id }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context 'ログインIDの桁数が12桁よりも大きい場合' do
      let(:login_id) { 'a' * 13 }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context 'パスワードの桁数が12桁よりも大きい場合' do
      let(:password) { 'b' * 13 }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end
  end
end
