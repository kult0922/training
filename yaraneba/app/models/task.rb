# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :user

  enum status: { waiting: 0, working: 1, completed: 2 }

  validates :title, presence: true
  validate :date_check

  def date_check
    now_date = Time.zone.today.strftime('%Y-%m-%d')
    err_msg = I18n.t('errors.messages.greater_than_or_equal_to', count: now_date)
    errors.add(I18n.t('tasks.common.end_date'), err_msg) if self.end_date.to_s < now_date
  end

  def self.search(params, user_id)
    Task.where('title LIKE ?', "%#{params[:search_title]}%").where('status LIKE ?', "%#{Task.statuses[params[:search_status]]}%").where(user_id: user_id)
  end
end
