# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }, allow_blank: false
  validates :due_date, presence: true
  validates :status, inclusion: { in: (0..2).to_a }

  belongs_to :app_user, dependent: :destroy

  # rubocop:disable Metrics/AbcSize
  def self.search_with_condition(search, page)
    if search.status.blank?
      Task.all.order(updated_at: search.sort_direction)
          .includes(:app_user)
          .page(page).per(10)
    else
      Task.where(status: search.status).order(updated_at: search.sort_direction)
          .includes(:app_user)
          .page(page).per(10)
    end
  end
  # rubocop:enable Metrics/AbcSize
end
