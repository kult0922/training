class Task < ApplicationRecord
  validates :name, presence: true
  belongs_to :user
  has_many :task_labels
  has_many :labels, through: :task_labels

  enum status: { not_proceed: 0, in_progress: 1, done: 2 }

  scope :where_status, ->(status) { where(tasks: { status: status }) if status.present? }
  scope :include_name, ->(name) { where(['tasks.name LIKE ?', "%#{name}%"]) if name.present? }
  scope :order_due_at, ->(column) { order(have_a_due: :desc) if column == 'due_at' }

  def self.rearrange(column, direction)
    order_due_at(column).order("#{design_column(column)} #{direction}")
  end

  def self.search(search)
    where_status(search[:status]).include_name(search[:name])
  end

  def self.design_column(column)
    case column
    when 'user_id'
      'users.name'
    else
      "tasks.#{column}"
    end
  end
end
