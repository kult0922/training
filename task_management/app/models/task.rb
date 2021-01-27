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

  def self.get_sort_key(sort_item, order)
    # ソートキーを設定
    if sort_item.blank? || order.blank?
      'creation_date' + ' ' + 'DESC'
    else
      sort_item + ' ' + order
    end
  end

  def self.search_tasks(user_id, sort_key, condition)
    # 検索ボタンを押下した場合
    if condition[:search_btn] == I18n.t('tasks.button.type.search')
      search_word = condition[:search_word]
      status = Task.statuses.values if condition[:status] == 'all'
      Task.where(user_id: user_id)
          .where(status: status)
          .where('name like ?', '%' + search_word + '%')
          .order(sort_key)
    else
      Task.where(user_id: user_id).order(sort_key)
    end
  end
end
