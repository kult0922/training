class Task < ApplicationRecord
  belongs_to :task_status
  belongs_to :user
  has_many :task_labelings, dependent: :destroy
  has_many :labels, through: :task_labelings

  validates :title, presence: true
  validates :description, presence: true
  validates :task_status_id, presence: true

  PER = 10

  scope :cache_status, -> {includes(:task_status)}
  scope :status, -> (status_id){where(task_status_id: status_id) if status_id.present? }
  scope :user, -> (user_id){where(user_id: user_id) if user_id.present? }
  scope :label, -> (label_id){joins(:labels).where(labels: {id: label_id}) if label_id.present? }
  scope :paging, -> (page){page(page).per(PER)}
  scope :search, -> (user_id, condition){
    cache_status.
    user(user_id).
    status(condition[:task_status_id]).
    label(condition[:label_id]).
    paging(condition[:page])
  }
end
