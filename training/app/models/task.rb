class Task < ApplicationRecord
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

  def self.order_by_priority(priority_order)
    order(due_date: priority_order)
  end
end
