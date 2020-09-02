class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 250 }
  validates :priority, presence: true, numericality: { only_integer: true }
  validates :status, presence: true
  validate :deadline_not_before_today

  enum status: { waiting: 1, working: 2, completed: 3}

  # バリデーション用のメソッドを定義
  def deadline_not_before_today
    errors.add(:deadline, 'は現在の日時以降のものを選択して下さい') if deadline.nil? || deadline < Date.today
  end

  # 終了期限新旧ソート機能
  def self.deadline_sort(selection)
    case selection
    when 'new' then
      all.order(deadline: :desc)
    when 'old' then
      all.order(deadline: :asc)
    else
      all.order(created_at: :desc)
    end
  end

  # ステータス検索
  def self.search_status(status)
    return where(status: status) if status.present?
    order(created_at: :desc)
  end

  # タスク名検索
  def self.search_title(title)
    where("title LIKE ?", "%#{title}%") if title.present?
    order(created_at: :desc)
  end  
  
  # 終了期限のコールバック
  before_save :deadline_blank?

  private
    def deadline_blank?
      self.deadline = DateTime.now if self.deadline.blank?
    end
end
