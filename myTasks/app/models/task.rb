class Task < ApplicationRecord
  enum status: { todo: 0, in_progress: 1, done: 2 }
  validates :name, presence: true
  validates :priority, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_blank: true
  validates :end_date, date: true
  def self.search(name, status, sort, direction)
    scope :sorted, -> { order("#{sort} #{direction}") }
    scope :filter_status, -> { where(status: [status]) }
    scope :search_name, -> { where(['name LIKE ?', "%#{name}%"]) }
    # 検索しないときは作成日の降順に表示
    return Task.order('created_at DESC') unless name
    # statusが選択されていないときはstatusの絞り込みを行わない
    return Task.search_name.sorted if status.blank?

    Task.filter_status.search_name.sorted
  end
end
