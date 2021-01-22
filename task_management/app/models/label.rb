# frozen_string_literal: true

# タスクテーブル
class Label < ApplicationRecord
  belongs_to :user
  has_many :task_label_relations, dependent: :destroy
  has_many :tasks, through: :task_label_relations

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
end
