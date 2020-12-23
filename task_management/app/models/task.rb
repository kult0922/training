class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label_relations, as: :task_label, dependent: :destroy

  # TODO:以下の日本語化
  enum priority: { low: 0, normal: 1, high: 2 }
  enum status: { todo: 0, in_progress: 1, done: 2 }
end
