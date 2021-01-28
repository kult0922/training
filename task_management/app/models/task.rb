# frozen_string_literal: true

# タスクテーブル
class Task < ApplicationRecord
  belongs_to :user
  has_many :task_label_relations, dependent: :destroy
  has_many :labels, through: :task_label_relations

  validates :name, presence: true, length: { maximum: 50 }
  validates :deadline, presence: true

  enum priority: { low: 1, normal: 2, high: 3 }
  enum status: { todo: 1, in_progress: 2, done: 3 }

  scope :get_status, ->(status) { where(status: status) if statuses.keys.include?(status) }

  scope :search_word, ->(search_word) { where('name like ?', "%#{search_word}%") if search_word.present? }

  scope :sort_key, (lambda do |sort_item, order|
    if sort_item.blank? || order.blank?
      sort_item = 'creation_date'
      order = 'DESC'
    end
    order(sort_item + ' ' + order)
  end)
end
