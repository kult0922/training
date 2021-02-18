# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TaskLabelRelation, type: :model do
  describe 'validation' do
    let(:authority) { create(:authority) }
    let(:user) { create(:user, authority_id: authority.id) }
    let(:task) { create(:task, user_id: user.id) }
    let(:label) { create(:label, user_id: user.id) }
    let(:task_id) { task.id }
    let(:label_id) { label.id }

    subject do
      build(
        :task_label_relation,
        task_id: task_id,
        label_id: label_id,
      )
    end

    context 'タスクID、ラベルIDが有る場合' do
      example '登録できる' do
        is_expected.to be_valid
      end
    end

    context 'タスクIDが無い場合' do
      let(:task_id) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end

    context 'ラベルIDが無い場合' do
      let(:label_id) { '' }
      example '登録できない' do
        is_expected.to_not be_valid
      end
    end
  end
end
