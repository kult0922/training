class Task < ApplicationRecord
  SORTABLE_COLUMNS = %w[deadline status].freeze
  validates :title, presence: true, length: { maximum: 20 }
  belongs_to :user
  has_many :task_label_relationships, dependent: :destroy
  has_many :labels, through: :task_label_relationships

  enum status: { not_start: 0, underway: 10, done: 20 }
  include Enum
  scope :search_title, (lambda do |title|
    title.present? ? where('title like ?', "%#{title}%") : all
  end)

  scope :search_status, (lambda do |status|
    status.present? ? where(status: status) : all
  end)

  scope :search_labels, (lambda do |label_ids|
    label_ids.present? ? where(labels: { id: label_ids }) : all
  end)

  def self.search(title, status, label_ids)
    search_title(title).search_status(status).search_labels(label_ids)
  end
end
