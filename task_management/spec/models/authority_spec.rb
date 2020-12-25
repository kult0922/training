require 'rails_helper'

RSpec.describe Authority, type: :model do
  describe 'validation' do
    let(:role) { 0 }
    let(:name) { 'Administrator' }

    subject do
      build(
        :authority,
        role: role,
        name: name
      )
    end

    context '権限区分と権限名が有る場合' do
      example '登録できる' do
        expect { is_expected.to be_valid }
      end
    end

    context '権限区分が無い場合' do
      let(:role) { '' }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

    context '権限名が無い場合' do
      let(:name) { '' }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

    context '権限区分が重複している場合' do
      let!(:test_role) { create(:authority) }
      let(:role) { test_role.role }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

  end
end
