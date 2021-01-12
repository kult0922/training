# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Label, type: :model do
  describe 'validation' do
    subject do
      build(
        :label,
        user_id: user.id,
        name: name
      )
    end

    context 'ユーザID、ラベル名が有る場合' do
      example '登録できる' do
        expect { is_expected.to be_valid }
      end
    end

    context 'ユーザIDが無い場合' do
      let(:user_id) { '' }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

    context 'ラベル名が無い場合' do
      let(:name) { '' }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

    context 'ラベル名が重複する場合' do
      let(:name) { 'test_label_1' }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

    context 'ラベル名の桁数が50桁よりも大きい場合' do
      let(:name) { 'a' * 51 }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end
  end
end
