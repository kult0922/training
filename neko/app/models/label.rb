class Label < ApplicationRecord
  validates :name, uniqueness: { case_sensitive: false }, length: { in: 2..24 }
  has_many :task_labels, dependent: :delete_all
  has_many :tasks, through: :task_labels
end
