# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 256 }
  validates :status, presence: true

  enum status: {
    yet: 0, # 未着手
    wip: 1, # 着手中
    done: 2 # 完了
  }

  def self.sort_task_by(params)
    sort = params[:sort] || 'created_at'
    direction = params[:direction] || 'desc'

    self.order("#{sort} #{direction}")
  end
end
