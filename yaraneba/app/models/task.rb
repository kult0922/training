# frozen_string_literal: true

class Task < ApplicationRecord
  enum status: { yet: 0, started: 1, done: 2 }

  validates :title, presence: true
  validate :date_check

  def date_check
    err_msg = I18n.t('errors.messages.greater_than_or_equal_to')
    now_date = Time.zone.today.strftime('%Y-%m-%d')
    errors.add(I18n.t('tasks.common.end_date'), err_msg, count: now_date) if self.end_date.to_s < now_date
  end
end
