class Task < ApplicationRecord
  belongs_to :task_status
  belongs_to :user
  has_many :task_labelings, dependent: :destroy
  has_many :labels, through: :task_labelings

  validates :title, presence: true
  validates :description, presence: true
  validates :task_status_id, presence: true

  scope :cache_status, -> {includes(:task_status)}
  scope :status, -> (status_id){where(task_status_id: status_id) if status_id.present? }
  scope :user, -> (user_id){where(user_id: user_id) if user_id.present? }
  scope :label, -> (label_id){joins(:labels).where("labels.id = '#{label_id}'") if label_id.present? }
  scope :paging, -> (page, per){page(page).per(per)}
  scope :search, -> (user_id, status_id, label_id, page, per){
    cache_status.status(status_id).user(user_id).label(label_id).paging(page, per)}
end
