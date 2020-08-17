# frozen_string_literal: true

class Task < ApplicationRecord
  enum priority: { low: 0, mid: 1, high: 2 }
  enum status: { todo: 0, in_progress: 1, done: 2 }
  belongs_to :project
  belongs_to :assignee, class_name: 'User'
  belongs_to :reporter, class_name: 'User'
  validates :task_name, presence: true
  validates :started_at, presence: true
  validates :finished_at, presence: true

  scope :order_finished_at, ->(order_by) { order(finished_at: order_by.to_sym) if order_by.present? }
  scope :name_search, ->(task_name) { where('task_name like ?', "%#{task_name}%")  if task_name.present? }
  scope :pri_search, ->(priority) { where(priority: priority) if priority.present? }
  scope :sta_search, ->(status) { where(status: status) if status.present? }
end
