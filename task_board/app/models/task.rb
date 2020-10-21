class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }

  enum priority: { low: 1, nomal: 2, high: 3 }
  enum status: { todo: 1, in_progress: 2, done: 3 }
end
