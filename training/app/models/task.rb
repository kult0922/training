class Task < ApplicationRecord
  validates :title, length: { maximum: 50 }
  validates :title, :priority, :status, presence: true
  validate  :due_date_not_before_today

  enum priority: {
    low: 0,
    medium: 1,
    hight: 2,
  }

  enum status: {
    waiting: 0,
    working: 1,
    done: 2,
  }

  def due_date_not_before_today
    errors.add(:due_date, I18n.t('errors.messages.due_date_is_past')) if due_date.present? && due_date < Date.today
  end
end
