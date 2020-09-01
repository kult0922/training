# frozen_string_literal: true

class Task < ApplicationRecord
  enum priority: { low: 0, mid: 1, high: 2 }
  enum status: { todo: 0, in_progress: 1, done: 2 }
  belongs_to :project
  belongs_to :assignee, class_name: 'User', foreign_key: :assignee_id
  belongs_to :reporter, class_name: 'User', foreign_key: :reporter_id
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels
  validates :task_name, presence: true
  validates :started_at, presence: true, date: true
  validates :finished_at, presence: true, date: true
  validate :finished_at_validate

  scope :order_by_at, ->(order_by) { order_by.present? ? order(finished_at: order_by.to_sym) : order(created_at: :desc) }
  scope :name_search, ->(task_name) { where('task_name like ?', "%#{task_name}%") if task_name.present? }
  scope :priority_search, ->(priority) { where(priority: priority) if priority.present? }
  scope :status_search, ->(status) { where(status: status) if status.present? }

  def finished_at_validate
    errors.add(:finished_at, I18n.t('errors.finished_at_not_before_stated_at')) unless started_at <= finished_at
  rescue StandardError
    errors.add(:finished_at, I18n.t('errors.finished_at_not_before_stated_at'))
  end
end
