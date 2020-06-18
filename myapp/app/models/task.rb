class Task < ApplicationRecord
  SORTABLE_COLUMNS = %w[deadline status].freeze
  validates :title, presence: true, length: { maximum: 20 }
  belongs_to :user

  enum status: { not_start: 0, underway: 10, done: 20 }
  include Enum
  scope :search_title, (lambda do |title|
    title.present? ? where('title like ?', "%#{title}%") : all
  end)

  scope :search_status, (lambda do |status|
    status.present? ? where(status: status) : all
  end)

  def self.search(title, status)
    search_title(title).search_status(status)
  end
end
