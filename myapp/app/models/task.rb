# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 256 }

  def self.sort_task_by(params)
    sort = params[:sort] || 'created_at'
    direction = params[:direction] || 'desc'

    self.order("#{sort} #{direction}")
  end
end
