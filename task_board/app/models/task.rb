class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50}

  enum priority: { "底" => 1, "中" => 2, "高" => 3 }
  enum status: { "未着手" => 1,"着手" => 2, "完了" => 3 }
end
