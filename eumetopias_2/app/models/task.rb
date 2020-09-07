class Task < ApplicationRecord
  belongs_to :task_status
  validates :title, presence: true
  validates :description, presence: true
  validates :task_status_id, presence: true

  scope :search_by_status_id, -> (term){where(task_status_id: term)}
end
