# frozen_string_literal: true

class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :priority, presence: true, numericality: { only_integer: true, greater_than: 0 }, uniqueness: true
end
