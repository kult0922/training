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

  def self.order_by_due_date(due_date_order)
    due_date_order = :asc if due_date_order.blank?
    order(due_date: due_date_order)
  end

  def self.search_by_title(title)
    return all if title.blank?
    where('title like ?', "%#{title}%")
  end

  def self.search_by_status(status)
    return all if status.blank?
    where(status: status)
  end
end
