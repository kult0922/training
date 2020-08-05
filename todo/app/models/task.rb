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

  def self.name_search(task_name, project_id)
    return Task.where(project_id: project_id) if task_name.blank?
    Task.where('task_name like ?', "%#{task_name}%")
  end

  def self.sta_search(status, project_id)
    return Task.where(project_id: project_id) if status.blank?
    Task.where(status: status)
  end

  def self.pri_search(priority, project_id)
    return Task.where(project_id: project_id) if priority.blank?
    Task.where(priority: priority)
  end

  def self.order_by(order_by, project_id)
    return Task.where(project_id: project_id) if order_by.blank?
    Task.order(finished_at: order_by)
  end
end
