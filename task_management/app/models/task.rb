# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label_relations, dependent: :destroy
  has_many :labels, through: :task_label_relations

  validates :name, presence: true, length: { maximum: 50 }
  validates :deadline, presence: true

  enum priority: { low: 1, normal: 2, high: 3 }
  enum status: { todo: 1, in_progress: 2, done: 3 }
end
