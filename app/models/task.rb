class Task < ApplicationRecord
  enum status: { not_start: 10, start: 20, done: 30 }

  # 入力必須
  validates :status, :title, :detail, presence: true

  # 3文字以上
  validates :title, :detail, length: { minimum: 3 }

  # 20文字以内
  validates :title, length: { maximum: 20 }

  # 200文字以内
  validates :detail, length: { maximum: 200 }

  # 終了期限は今日以降の日のみ
  validate :date_before_start

  def date_before_start
    errors.add(:end_date, I18n.t('msg.validate_end_date')) if !end_date.nil? && end_date < Date.today
  end
end
