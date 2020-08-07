# frozen_string_literal: true

class Task < ApplicationRecord
  enum priority: { low: 0, mid: 1, high: 2 }
  belongs_to :project
  belongs_to :assignee, class_name: 'User'
  belongs_to :reporter, class_name: 'User'
  validates :task_name, presence: true
  validates :started_at, presence: true
  validates :finished_at, presence: true

  scope :find_pj_tasks, ->(project) { project.tasks }
  scope :order_finished_at, ->(order_by) { order(finished_at: order_by.to_sym) if order_by.present? }
end
