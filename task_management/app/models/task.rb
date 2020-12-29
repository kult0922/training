# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label_relations, dependent: :destroy
  has_many :labels, through: :task_label_relations

  validates :name, presence: true, length: { maximum: 50 }
  validates :details, presence: true
  validates :deadline, presence: true

  enum priority: { low: 0, normal: 1, high: 2 }
  enum status: { todo: 0, in_progress: 1, done: 2 }
end
