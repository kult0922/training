# frozen_string_literal: true

class Task < ApplicationRecord
  attribute :input_task_label, :string
  attr_accessor :input_task_label
  validates :name, presence: true, length: { maximum: 100 }
  validates :due_date, presence: true
  validates :status, inclusion: { in: (0..2).to_a }

  belongs_to :app_user
  has_many :task_labels, dependent: :destroy

  # rubocop:disable Metrics/AbcSize
  def self.search_with_condition(search, page, current_user)
    if search.status.blank?
      query = if current_user&.admin?
                Task.all
              else
                Task.where(app_user: current_user)
              end
    else
      query = Task.where(status: search.status)
      query = query.where(app_user: current_user) unless current_user.admin?
    end
    query.order(updated_at: search.sort_direction)
        .includes(:app_user)
        .includes(:task_labels)
        .page(page).per(10)
  end
  # rubocop:enable Metrics/AbcSize
end
