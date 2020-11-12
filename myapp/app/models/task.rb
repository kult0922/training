class Task < ApplicationRecord
  belongs_to :user

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
