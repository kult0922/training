class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { minimum: 1, maximum: 100 }
  validates :description, length: { maximum: 2000 }

  enum status: {
    todo: 0,
    doing: 1,
    done: 2,
  }

  enum priority: {
    low: -1,
    medium: 0,
    high: 1,
  }
end
