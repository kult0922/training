# frozen_string_literal: true

# タスクテーブル-ラベルマスタ紐付テーブル
class TaskLabelRelation < ApplicationRecord
  belongs_to :task
  belongs_to :label
end
