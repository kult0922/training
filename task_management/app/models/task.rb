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

  scope :where_status, ->(status) { where(status: status) if statuses.keys.include?(status) }
  scope :where_search_word, ->(search_word) { where('name like ?', "%#{search_word}%") if search_word.present? }
  scope :where_task_ids, (lambda do |params|
    # 検索ボタンが押下された場合
    if params[:search_btn] == I18n.t('tasks.button.type.search')
      label_ids = params[:label_ids]
      if label_ids.blank?
        where.not(id: TaskLabelRelation.joins(:label).select('task_label_relations.task_id'))
      else
        where(id: find_task_id(label_ids))
      end
    end
  end)

  scope :order_sort_column, (lambda do |sort_item, order|
    if sort_item.blank? || order.blank?
      sort_item = 'creation_date'
      order = 'DESC'
    end
    order(sort_item + ' ' + order)
  end)

  scope :find_tasks, (lambda do |user_id, params, order|
    where(user_id: user_id)
    .where_task_ids(params)
    .preload(:labels)
    .where_status(params[:status])
    .where_search_word(params[:search_word])
    .order_sort_column(params[:sort], order)
    .page(params[:page])
  end)

  def find_task_id(label_ids)
    task_id_ary = []
    task_label_relations = TaskLabelRelation.where(label_id: label_ids)
    task_label_relations.each do |task_label|
      task_id_ary.push task_label.task_id if task_label.task_id.present?
    end
    task_id_ary
  end
end
