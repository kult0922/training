class Task < ApplicationRecord
  enum status: { todo: 0, in_progress: 1, done: 2 }
  validates :name, presence: true
  validates :priority, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_blank: true
  scope :sorted, -> (sort, direction) { order("#{sort} #{direction}") }
  scope :filter_status, -> (status) { where(status: [status]) }
  scope :search_name, -> (name) { where(['name LIKE ?', "%#{name}%"]) }

  def self.search(name, status, sort, direction)
    # directionに不正な値が入っているときは昇順に設定
    direction = 'ASC' if direction != 'ASC' && direction != 'DESC'

    # 検索しないときは作成日の降順に表示
    return order('created_at DESC') unless name
    # statusが選択されていないときはstatusの絞り込みを行わない
    return search_name(name).sorted(sort, direction) if status.blank?

    filter_status(status).search_name(name).sorted(sort, direction)
  end
end
