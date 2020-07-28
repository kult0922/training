class Label < ApplicationRecord
  validates :name, presence: true, length: { maximum: 10 }
  has_many :task_labels, dependent: :delete_all
  has_many :tasks, through: :task_labels
  belongs_to :user
end
