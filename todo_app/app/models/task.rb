class Task < ApplicationRecord
  validates :title, presence: true
  validates :description, presence: true

  scope :sort_tasks, ->(request_sort) do
    # request_sort = { key: value }
    request_sort.present? ? order(request_sort) : order(:id)
  end
end
