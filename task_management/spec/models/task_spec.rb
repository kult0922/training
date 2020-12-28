require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    subject do
      build(
        :task,
        user_id { user.id },
        name: name,
        details: details,
        deadline: deadline,
        status: status,
        priority: priority,
        creation_date: creation_date
      )
    end

    context 'ユーザID、タスク名、タスク詳細、終了期限、ステータス、優先順位、作成日時が有る場合' do
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

    context 'タスク名が無い場合' do
      let(:name) { '' }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

    context '終了期限が無い場合' do
      let(:deadline) { '' }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

    context 'ステータスが無い場合' do
      let(:status) { '' }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

    context '優先順位が無い場合' do
      let(:priority) { '' }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

    context '作成日時が無い場合' do
      let(:creation_date) { '' }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

    context 'ステータスが2桁よりも大きい場合' do
      let(:status) { 12 }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

    context '優先順位が2桁よりも大きい場合' do
      let(:priority) { 12 }
      example '登録できない' do
        expect { is_expected.to_not be_valid }
      end
    end

  end
end
