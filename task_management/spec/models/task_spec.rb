# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    let!(:test_authority) do
      create(:authority,
             role: 1,
             name: 'test')
    end
    let!(:test_user) do
      create(:user,
             authority_id: test_authority.id)
    end
    let(:user_id) { test_user.id }
    let(:name) { 'test_name' }
    let(:details) { 'test_details' }
    let(:deadline) { Time.zone.now + 3.days }
    let(:status) { 1 }
    let(:priority) { 1 }
    let(:creation_date) { Time.zone.now }

    subject do
      build(
        :task,
        user_id: user_id,
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
        is_expected.to be_valid
      end
    end

    context 'ユーザIDが無い場合' do
      let(:user_id) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context 'タスク名が無い場合' do
      let(:name) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context '終了期限が無い場合' do
      let(:deadline) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    describe 'enums' do
      context '優先順位とステータスが正しく定義されている場合' do
        example '登録できる' do
          should define_enum_for(:priority).with_values(low: 1, normal: 2, high: 3)
          should define_enum_for(:status).with_values(todo: 1, in_progress: 2, done: 3)
        end
      end
    end
  end
end
