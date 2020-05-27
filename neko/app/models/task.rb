class Task < ApplicationRecord
  validates :name, presence: true

  enum status: { not_proceed: 0, in_progress: 1, done: 2 }

  scope :where_status, ->(status) { where(status: status) if status.present? }
  scope :include_name, ->(name) { where(['name LIKE ?', "%#{name}%"]) if name.present? }
  scope :order_due, ->(column) { order(have_a_due: :desc) if column == 'due_at' }

  def self.rearrange(column, direction)
    order_due(column).order("#{column} #{direction}")
  end

  def self.search(search)
    where_status(search[:status]).include_name(search[:name])
  end
end
