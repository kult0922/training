# frozen_string_literal: true

class Project < ApplicationRecord
  enum status: { todo: 0, in_progress: 1, in_review: 2, release: 3, done: 4 }
  has_many :tasks, dependent: :delete_all
  has_many :user_projects, dependent: :delete_all
  has_many :users, through: :user_projects
  validates :project_name, presence: true, uniqueness: { case_sensitive:  true }
  validates :started_at, presence: true, date: true
  validates :finished_at, presence: true, date: true
  validate :finished_at_validate

  def finished_at_validate
    errors.add(:finished_at, I18n.t('errors.finished_at_not_before_stated_at')) unless started_at <= finished_at
  rescue StandardError
    errors.add(:finished_at, I18n.t('errors.finished_at_not_before_stated_at'))
  end
end
