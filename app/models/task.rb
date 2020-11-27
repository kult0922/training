class Task < ApplicationRecord

  enum status: { 未着手: 10, 着手: 20, 完了: 30 }

  #入力必須
  validates :status, :title, :detail, presence: true

  #3文字以上
  validates :title, :detail, length: { minimum: 3 }

  #20文字以内
  validates :title, length: { maximum: 20 }

  #200文字以内
  validates :detail, length: { maximum: 200 }

end
