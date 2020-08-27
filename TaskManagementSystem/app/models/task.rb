class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 250 }
  validates :priority, presence: true, numericality: { only_integer: true }
  validates :status, presence: true
  validate :deadline_not_before_today

  enum status: { waiting: 0, working: 1, completed: 2}

  # バリデーション用のメソッドを定義
  def deadline_not_before_today
    errors.add(:deadline, 'は現在の日時以降のものを選択して下さい') if deadline.nil? || deadline < Date.today
  end

  # 終了期限新旧ソート機能
  def self.sort(selection)
    case selection
    when 'new' then
      all.order(deadline: :desc)
    when 'old' then
      all.order(deadline: :asc)
    else
      all.order(created_at: :desc)
    end
  end
end
