class Label < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :user }, length: { maximum: 30 }
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :tasks, through: :task_labels
end
