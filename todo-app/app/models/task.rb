# frozen_string_literal: true

class Task < ApplicationRecord
  PER_PAGE = 10
  # rubocop:disable Style/SymbolArray
  enum statuses: [:open, :in_progress, :close]
  # rubocop:enabled Style/SymbolArray

  validates :name, presence: true, length: { maximum: 100 }, allow_blank: false
  validates :due_date, presence: true
  validates :status, inclusion:  { in: Task.statuses.values }

  belongs_to :app_user, dependent: :destroy

  # rubocop:disable Metrics/AbcSize
  def self.search_with_condition(search, page)
    if search.status.blank?
      Task.all.order(updated_at: search.sort_direction)
          .includes(:app_user)
          .page(page).per(PER_PAGE)
    else
      Task.where(status: search.status).order(updated_at: search.sort_direction)
          .includes(:app_user)
          .page(page).per(PER_PAGE)
    end
  end
  # rubocop:enable Metrics/AbcSize
end
