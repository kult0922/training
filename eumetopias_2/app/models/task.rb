class Task < ApplicationRecord
  belongs_to :task_status
  validates :title, presence: true
  validates :description, presence: true
end
