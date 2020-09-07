# frozen_string_literal: true

class Task < ApplicationRecord
  # relation
  belongs_to :user

  # validation
  validates :title, presence: true, length: { maximum: 256 }
  validates :status, presence: true

  # enum
  enum status: {
    yet: 0, # 未着手
    wip: 1, # 着手中
    done: 2, # 完了
  }

  # class mothods
  def self.sort_task_by(sort, direction)
    sort ||= 'created_at'
    direction ||= 'desc'

    self.order("#{sort} #{direction}")
  end
end
