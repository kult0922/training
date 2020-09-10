# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 250 }
  validates :priority, presence: true, numericality: { only_integer: true }
  validates :status, presence: true
  validate :deadline_not_before_today

  belongs_to :user

  enum status: { waiting: 1, working: 2, completed: 3 }

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
  scope :search_with_status, -> (status) { where(status: status) if status.present? }

  # タスク名検索
  scope :search_with_title, -> (title) { where('title LIKE ?', "%#{title}%") if title.present? }

  # 終了期限のコールバック
  before_save :deadline_blank?

  private

  def deadline_blank?
    self.deadline = DateTime.now if self.deadline.blank?
  end
end
