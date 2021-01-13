# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  before :all do
    @test_authority =
      create(:authority,
             id: 1,
             role: 0,
             name: 'test')

    @test_user =
      create(:user,
             authority_id: @test_authority.id)
  end

  after :all do
    DatabaseCleaner.clean_with(:truncation)
  end

  let!(:user_id) { @test_user.id }
  subject do
    build(
      :label,
      user_id: user_id,
      name: name
    )
  end

  describe 'validation' do
    context 'ユーザID、ラベル名が有る場合' do
      let!(:name) { 'test' }
      example '登録できる' do
        is_expected.to be_valid
      end
    end

    context 'ユーザIDが無い場合' do
      let(:user_id) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context 'ラベル名が無い場合' do
      let(:name) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context 'ラベル名が重複する場合' do
      let!(:test_label) do
        create(:label,
               name: 'test_label',
               user_id: @test_user.id)
      end
      let(:name) { test_label.name }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context 'ラベル名の桁数が50桁よりも大きい場合' do
      let(:name) { 'a' * 51 }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end
  end
end
