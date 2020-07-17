# frozen_string_literal: true

class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 100 }, allow_blank: false
  validates :due_date, presence: true
  validates :status, inclusion: { in: (0..2).to_a }

  belongs_to :app_user

  # rubocop:disable Metrics/AbcSize
  def self.search_with_condition(search, page, current_user)
    if search.status.blank?
      if current_user.is_admin?
        query = Task.all
      else
        query = Task.where(app_user: current_user)
      end
      query.order(updated_at: search.sort_direction)
          .includes(:app_user)
          .page(page).per(10)
    else
      query = Task.where(status: search.status)
      unless current_user.is_admin?
        query = query.where(app_user: current_user)
      end
      query.order(updated_at: search.sort_direction)
          .includes(:app_user)
          .page(page).per(10)
    end
  end
  # rubocop:enable Metrics/AbcSize
end
