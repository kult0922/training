class Task < ApplicationRecord
  belongs_to :task_status
  belongs_to :user
  has_many :task_labelings, dependent: :destroy
  has_many :labels, through: :task_labelings

  validates :title, presence: true
  validates :description, presence: true
  validates :task_status_id, presence: true


  scope :search_by_status_id, -> (term){where(task_status_id: term)}
end
