# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authority, type: :model do
  before :all do
    @test_authority =
      create(:authority,
             role: 0,
             name: 'test')
  end

  after :all do
    DatabaseCleaner.clean_with(:truncation)
  end

  describe 'validation' do
    let(:role) { @test_authority.role }
    let(:name) { @test_authority.name }

    subject do
      build(
        :authority,
        role: role,
        name: name,
      )
    end

    context '権限区分、権限名が有る場合' do
      let(:role) { 1 }
      let(:name) { 'test_name' }
      example '登録できる' do
        is_expected.to be_valid
      end
    end

    context '権限区分が無い場合' do
      let(:role) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context '権限名が無い場合' do
      let(:name) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context '権限区分の桁数が1桁よりも大きい場合' do
      let(:role) { 12 }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context '権限名の桁数が50桁よりも大きい場合' do
      let(:name) { 'a' * 51 }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context '権限区分が重複する場合' do
      let!(:test_authority) do
        create(:authority,
               role: 1,
               name: 'test_name')
      end
      let(:name) { 'test1' }
      let(:role) { test_authority.role }
      example '登録できる' do
        is_expected.to be_valid
      end
    end

    context '権限名が重複する場合' do
      let!(:test_authority) do
        create(:authority,
               role: 2,
               name: 'duplicated')
      end
      let(:name) { test_authority.name }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context '権限名の桁数が50桁よりも大きい場合' do
      let(:name) { 'a' * 51 }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end
  end
end
