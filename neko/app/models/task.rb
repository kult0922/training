class Task < ApplicationRecord
  validates :name, length: { in: 2..24 }
  belongs_to :user
  has_many :task_labels, dependent: :delete_all
  has_many :labels, through: :task_labels

  enum status: { not_proceed: 0, in_progress: 1, done: 2 }

  scope :where_status, ->(status) { where(tasks: { status: status }) if status.present? }
  scope :include_name, ->(name) { where(['tasks.name LIKE ?', "%#{name}%"]) if name.present? }
  scope :have_label,   ->(label_ids) {
    if label_ids.present?
      task_ids = Task.joins(:labels).where(labels: { id: label_ids }).select('id')
      where(id: task_ids)
    end
  }

  scope :order_due_at, ->(column) { order(have_a_due: :desc) if column == 'due_at' }

  def self.rearrange(column, direction)
    order_due_at(column).order("#{design_column(column)} #{direction}")
  end

  def self.search(search)
    where_status(search[:status]).include_name(search[:name]).have_label(search[:label_ids])
  end

  def self.design_column(column)
    column == 'user_id' ? 'users.name' : "tasks.#{column}"
  end
end
